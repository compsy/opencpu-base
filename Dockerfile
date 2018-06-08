# How to test using OpenCPU:
#   1. docker build -t autovar .
#   2. docker run -p 80:80 autovar
#   3. Go to <docker IP>/ocpu/test
# Based on https://hub.docker.com/r/opencpu/base/~/dockerfile/

# Use builds from launchpad
FROM ubuntu:18.04
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install.
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.0 && \
  apt-get update && \
  apt-get install -y opencpu-server

# Prints apache logs to stdout
RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

## Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service cron start && apachectl -DFOREGROUND

