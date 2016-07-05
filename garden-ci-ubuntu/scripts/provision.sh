set -e -x

# seccomp profiles require a recent (>= 2.2.1) version of seccomp
echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list

# install build dependencies
# - graphviz is for rendering heap w/ pprof
apt-get update && \
apt-get -y --force-yes install \
  build-essential \
  curl \
  git \
  graphviz \
  htop \
  libpython-dev \
  lsof \
  psmisc \
  python \
  strace \
  wget \
  iptables \
  aufs-tools \
  quota \
  ulogd \
  pkg-config \
  libseccomp2/jessie-backports \
  libseccomp-dev/jessie-backports

# install go1.6.1
wget -qO- https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -

#Set up $GOPATH and add go executables to $PATH
cat > /etc/profile.d/go_env.sh <<\EOF
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
EOF
chmod +x /etc/profile.d/go_env.sh

export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH

# create dir for rootfses to upload to
mkdir -p /opt/warden
chmod 0777 /opt/warden
