FROM ubuntu:trusty

ENV PATH=/root/.local/bin:$PATH

RUN apt-get update && apt-get install -y python-dev python-pip \
  && pip install --upgrade --user pip \
  && /root/.local/bin/pip install --user ansible
