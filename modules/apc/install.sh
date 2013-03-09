#!/bin/bash

install_nginx() {

  # Downloading
  wget -O ${sources}/APC-3.1.13.tgz "http://pecl.php.net/get/APC-3.1.13.tgz"

  # Extracting
  tar xzvf ${sources}/APC-3.1.13.tgz -C ${sources}
  cd ${sources}/APC-3.1.13

  # Compiling
  /usr/local/php5/bin/phpize -clean
  ./configure --enable-apc --with-php-config=/usr/local/php5/bin/php-config --with-libdir=/usr/local/php5/lib/php
  make -j8
  make install

  # Configuring
  echo 'extension = apc.so
apc.enabled = 1
apc.shm_size = 128M
apc.shm_segments=1
apc.write_lock = 1
apc.rfc1867 = On
apc.ttl=7200
apc.user_ttl=7200
apc.num_files_hint=1024
apc.mmap_file_mask=/tmp/apc.XXXXXX
apc.enable_cli=1
; Optional, for "[apc-warning] Potential cache slam averted for key... errors"
; apc.slam_defense = Off' > /etc/php5/conf.d/apc.ini

}