#!/bin/bash

install_vsftpd() {

  # Downloading
  wget -O ${sources}/vsftpd-3.0.2.tar.gz "https://security.appspot.com/downloads/vsftpd-3.0.2.tar.gz"

  # Extracting
  tar xzvf ${sources}/vsftpd-3.0.2.tar.gz -C ${sources}
  cd ${sources}/vsftpd-3.0.2

  # Compiling
  make -j8

  # Configuring
  mkdir -p /usr/share/empty /var/ftp /usr/local/man/man5 /usr/local/man/man8

  useradd -d /var/ftp ftp
  chown root.root /var/ftp
  chmod og-w /var/ftp

  cp vsftpd.conf /etc

  cp ${modules}/vsftpd/init.d/vsftpd /etc/init.d/vsftpd
  chmod +x /etc/init.d/vsftpd

  update-rc.d -f vsftpd defaults

  # Installing
  make install

  # Logrotate
  echo '/var/log/vsftpd.log {
  weekly
  sharedscripts
  missingok
  notifempty
  postrotate
  /etc/init.d/vsftpd restart > /dev/null 2>&1 || true
  endscript
}' > /etc/logrotate.d/vsftpd


}