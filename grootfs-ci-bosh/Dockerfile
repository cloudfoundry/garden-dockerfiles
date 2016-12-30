FROM cfgarden/grootfs-ci
MAINTAINER https://github.com/cloudfoundry/garden-dockerfiles

USER root

################################
# Install system packages
RUN apt-get update && \
    apt-get -y install \
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

##############################
# Install Bosh
RUN gem install bundler --no-rdoc --no-ri
RUN gem install bosh_cli -v 1.3232.0 --no-rdoc --no-ri

