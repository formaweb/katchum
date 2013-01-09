#!/bin/bash

install_php5() {

  # Downloading
  wget -O ${sources}/php-5.4.10.tar.gz "http://us.php.net/distributions/php-5.4.10.tar.gz"

  # Extracting
  tar xzvf ${sources}/php-5.4.10.tar.gz -C ${sources}
  cd ${sources}/php-5.4.10

  # Installing Dependencies
  apt-get -y install libmysqlclient-dev mysql-client libcurl4-openssl-dev libgd2-xpm-dev libjpeg-dev libpng3-dev libxpm-dev libfreetype6-dev libt1-dev libmcrypt-dev libxslt1-dev bzip2 libbz2-dev libxml2-dev libevent-dev libltdl-dev libmagickwand-dev libmagickcore-dev imagemagick libreadline-dev libc-client-dev libsnmp-dev snmpd snmp libpq-dev

  # Fixings
  if [ $(arch) == "i686" ]; then
    arch=i386-linux-gnu
  else
    arch=$(arch)-linux-gnu
  fi

  [ -f /usr/lib/${arch}/libjpeg.so ] && ln -fs /usr/lib/${arch}/libjpeg.so /usr/lib/
  [ -f /usr/lib/${arch}/libpng.so ] && ln -fs /usr/lib/${arch}/libpng.so /usr/lib/
  [ -f /usr/lib/${arch}/libXpm.so ] && ln -fs /usr/lib/${arch}/libXpm.so /usr/lib/
  [ -f /usr/lib/${arch}/libmysqlclient.so ] && ln -fs /usr/lib/${arch}/libmysqlclient.so /usr/lib/
  [ -d /usr/lib/${arch}/mit-krb5 ] && ln -fs /usr/lib/${arch}/mit-krb5/lib*.so /usr/lib/

  # Compiling
  ./buildconf --force
  ./configure --prefix=/usr/local/php5 --with-config-file-path=/etc/php5 --with-config-file-scan-dir=/etc/php5/conf.d --with-curl --with-pear --with-gd --with-jpeg-dir --with-png-dir --with-zlib --with-xpm-dir --with-freetype-dir --with-t1lib --with-mcrypt --with-mhash --with-mysql --with-pgsql --with-mysqli --with-pdo-mysql --with-pdo-pgsql --with-openssl --with-xmlrpc --with-xsl --with-bz2 --with-gettext --with-readline --with-fpm-user=www-data --with-fpm-group=www-data --with-imap --with-imap-ssl --with-kerberos --with-snmp --disable-debug --enable-fpm --enable-cli --enable-inline-optimization --enable-exif --enable-wddx --enable-zip --enable-bcmath --enable-calendar --enable-ftp --enable-mbstring --enable-soap --enable-sockets --enable-shmop --enable-dba --enable-sysvsem --enable-sysvshm --enable-sysvmsg
  make -j8
  make install

  # Configuring
  mkdir -p /etc/php5/conf.d /var/log/php5-fpm
  chown -R www-data:www-data /var/log/php5-fpm

  cp -f php.ini-production /etc/php5/php.ini
  TIMEZONE=$([ -f /etc/timezone ] && cat /etc/timezone | sed "s/\//\\\\\//g")
  sed -i "s/^\;date\.timezone.*$/date\.timezone = \"${TIMEZONE}\" /g" /etc/php5/php.ini

  cp ${modules}/php5/fpm/php-fpm.conf /etc/php5/php-fpm.conf

  cp ${modules}/php5/init.d/php5-fpm /etc/init.d/php5-fpm
  chmod +x /etc/init.d/php5-fpm

  update-rc.d -f php5-fpm defaults

  # Logrotate
  echo '/var/log/php5-fpm/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  create 640 www-data www-data
  sharedscripts
  postrotate
    [ ! -f /var/run/php5-fpm.pid ] || kill -USR1 `cat /var/run/php5-fpm.pid`
  endscript
}' > /etc/logrotate.d/php5-fpm

}