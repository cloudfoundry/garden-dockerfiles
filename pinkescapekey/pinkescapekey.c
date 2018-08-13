#include <stdbool.h>
#include <time.h>

int main()
{
  while(true) {
    struct timespec tim;
    tim.tv_sec = 0;
    tim.tv_nsec = 10;
    if(nanosleep(&tim , NULL) < 0)
    {
      return -1;
    }
  }
  return 0;
}
