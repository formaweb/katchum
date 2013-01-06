#!/bin/bash

install_php5() {
  add-apt-repository -y ppa:ondrej/php5
  apt-get update
  apt-get -y install php5-cli php5-fpm php5-curl php5-mysql php5-gd php-apc

  cp ${modules}/php5/fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf

  mkdir /var/log/php5
}