#!/bin/bash

install_dialog() {

  # Downloading
  wget -O ${sources}/dialog.tar.gz "http://invisible-island.net/datafiles/release/dialog.tar.gz"

  # Extracting
  tar xzvf ${sources}/dialog.tar.gz -C ${sources}
  cd ${sources}/dialog*

  # Installing Dependencies
  apt-get -y install libncurses5-dev

  # Compiling
  ./configure
  make -j8
  make install

  # Ending
  cd ${directory}
}