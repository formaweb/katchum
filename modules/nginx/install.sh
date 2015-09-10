#!/bin/bash

install_nginx() {

  # Downloading
  wget -O ${sources}/nginx-1.9.4.tar.gz "http://nginx.org/download/nginx-1.9.4.tar.gz"

  # Extracting
  tar xzvf ${sources}/nginx-1.9.4.tar.gz -C ${sources}
  cd ${sources}/nginx-1.9.4

  # Installing Dependencies
  apt-get -y install libpcre3 libpcre3-dev libssl-dev

  # Compiling
  ./configure --prefix=/usr/local/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_gzip_static_module --with-ipv6 --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module
  make -j8
  make install

  # Configuring
  mkdir -p /etc/nginx/defaults /etc/nginx/sites-available /etc/nginx/sites-enabled /var/log/nginx
  chown -R www-data:www-data /var/log/nginx

  cp ${modules}/nginx/nginx.conf /etc/nginx/nginx.conf

  cp ${modules}/nginx/defaults/assets.conf /etc/nginx/defaults/assets.conf
  cp ${modules}/nginx/defaults/cache-busting.conf /etc/nginx/defaults/cache-busting.conf
  cp ${modules}/nginx/defaults/cross-domain-ajax.conf /etc/nginx/defaults/cross-domain-ajax.conf
  cp ${modules}/nginx/defaults/cross-domain-fonts.conf /etc/nginx/defaults/cross-domain-fonts.conf
  cp ${modules}/nginx/defaults/no-transform.conf /etc/nginx/defaults/no-transform.conf
  cp ${modules}/nginx/defaults/php.conf /etc/nginx/defaults/php.conf
  cp ${modules}/nginx/defaults/protect-system-files.conf /etc/nginx/defaults/protect-system-files.conf
  cp ${modules}/nginx/defaults/ruby.conf /etc/nginx/defaults/ruby.conf
  cp ${modules}/nginx/defaults/x-ua-compatible.conf /etc/nginx/defaults/x-ua-compatible.conf

  cp ${modules}/nginx/sites-available/default /etc/nginx/sites-available/default
  ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

  cp ${modules}/nginx/init.d/nginx /etc/init.d/nginx
  chmod +x /etc/init.d/nginx

  update-rc.d -f nginx defaults

  # Logrotate
  echo '/var/log/nginx/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  create 640 root adm
  sharedscripts
  postrotate
    [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`
  endscript
}' > /etc/logrotate.d/nginx

}
