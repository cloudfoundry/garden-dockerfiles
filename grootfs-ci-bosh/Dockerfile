FROM cfgarden/grootfs-ci
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

################################
# Install system packages
RUN sudo apt-get update && \
    sudo apt-get -y install \
        libcurl4-openssl-dev \
        libreadline6-dev \
        libssl-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        ruby \
        ruby-dev \
        unzip \
        zlib1g-dev && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

##############################
# Install Bosh
RUN sudo gem install bundler --no-rdoc --no-ri
RUN sudo gem install bosh_cli -v 1.3232.0 --no-rdoc --no-ri
