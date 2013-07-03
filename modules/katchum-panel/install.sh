#!/bin/bash

install_apc() {

  curl get.mojolicio.us | sh
  curl -L cpanmin.us | perl - App::cpanminus
  cpanm Passwd::Unix

  mkdir /var/www/katchum
  cp ${directory}/panel /var/www/katchum

}