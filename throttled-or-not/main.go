package main

import (
	"container/ring"
	"errors"
	"fmt"
	"io/ioutil"
	"math"
	"net/http"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

var (
	theSpinner *spinner
)

func main() {
	theSpinner = NewSpinner()

	http.HandleFunc("/spin", spinHandler)
	http.HandleFunc("/unspin", unspinHandler)
	http.HandleFunc("/lastavg", lastavgHandler)
	http.HandleFunc("/cpucgroup", cpuCgroupHandler)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

const historyLen = 10

type spinner struct {
	history     *ring.Ring
	minAverage  float64
	maxAverage  float64
	lastAverage float64
	isSpinning  int64
	spinMutex   sync.Mutex
	stopCh      chan struct{}
}

func NewSpinner() *spinner {
	s := &spinner{stopCh: make(chan struct{})}
	s.history = ring.New(historyLen)
	return s
}

func spinHandler(w http.ResponseWriter, r *http.Request) {
	if err := theSpinner.Spin(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func unspinHandler(w http.ResponseWriter, r *http.Request) {
	if err := theSpinner.Unspin(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func lastavgHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%f", theSpinner.lastAverage)
}

func cpuCgroupHandler(w http.ResponseWriter, r *http.Request) {
	var contents []byte
	var err error
	if contents, err = ioutil.ReadFile("/proc/self/cgroup"); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	for _, line := range strings.Split(string(contents), "\n") {
		if strings.Contains(line, "cpu") {
			fmt.Fprint(w, line)
			return
		}
	}

	http.Error(w, "No CPU cgroup found", http.StatusInternalServerError)
}

func (s *spinner) Spin() error {
	s.spinMutex.Lock()
	defer s.spinMutex.Unlock()

	if atomic.LoadInt64(&s.isSpinning) > 0 {
		return errors.New("already spinning")
	}
	go s.spin()
	atomic.StoreInt64(&s.isSpinning, 1)

	return nil
}

func (s *spinner) Unspin() error {
	s.spinMutex.Lock()
	defer s.spinMutex.Unlock()

	if atomic.LoadInt64(&s.isSpinning) < 1 {
		return errors.New("not spinning")
	}

	s.stopCh <- struct{}{}
	atomic.StoreInt64(&s.isSpinning, 0)
	return nil
}

func (s *spinner) spin() {
	period := 100 * time.Millisecond
	s.maxAverage = 0
	s.minAverage = math.MaxFloat64
	for {
		select {
		case <-s.stopCh:
			return
		default:
			n := s.countIterations(period)
			s.history.Value = n
			s.history = s.history.Next()
			s.lastAverage = s.Average()
			if s.lastAverage > s.maxAverage {
				s.maxAverage = s.lastAverage
			}
			if s.lastAverage < s.lastAverage {
				s.minAverage = s.lastAverage
			}
		}
	}
}

func (s *spinner) Average() float64 {
	total := 0
	count := 0
	s.history.Do(func(p interface{}) {
		if p != nil {
			total += p.(int)
			count++
		}
	})
	if count == 0 {
		return 0
	}
	return float64(total) / float64(count)
}

func (s *spinner) PrintHistory() {
	s.history.Do(func(p interface{}) {
		fmt.Printf("%d ", p.(int))
	})
	fmt.Println()
}

func (s *spinner) countIterations(period time.Duration) int {
	var i int
	timeOut := time.After(period)
	for {
		select {
		case <-timeOut:
			return i
		default:
			naive_fib(silly_fib_to_get)
			i = i + 1
		}
	}
}

const silly_fib_to_get = 24

func naive_fib(n int) int {
	if n < 1 {
		panic(fmt.Sprintf("bad input: %d", n))
	}
	if n < 3 {
		return 1
	}
	return naive_fib(n-1) + naive_fib(n-2)
}
