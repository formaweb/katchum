#!/bin/bash

# Variables
directory=`dirname $(readlink -f $0)`
formulas="${directory}/modules/*/install.sh"
modules="${directory}/modules"
sources="${directory}/sources"
title="Katchum"

# Is Root?
if [ $(id -u) != "0" ]; then
  echo "Error: You must be root to run this installer. You can try again using 'sudo'."
  exit 1
fi

# Load Formulas
for file in ${formulas} ; do
  . ${file}
done

# Update System
apt-get update
apt-get -y upgrade

# Essentials Instalation
apt-get -y install curl openssl git-core python-software-properties build-essential

# Source Directory
if [ ! -d "${sources}" ]; then
  mkdir ${sources}
fi

# Dialog
command -v dialog > /dev/null 2>&1 || { install_dialog; }

# Katchum
dialog \
  --backtitle ${title} \
  --title 'License Information' \
  --textbox LICENSE \
  0 0

selected_modules=$( dialog --stdout \
  --separate-output \
  --backtitle ${title} \
  --title 'Packages' \
  --checklist 'Select the packages you want to install.' \
  0 0 0 \
  nginx  ''  on \
  php5  ''  on \
  rbenv  ''  on \
  mysql  ''  on \
  postfix  ''  on \
  imagemagick  ''  on )

echo "$selected_modules" | while read module
do
  `install_${module}`
done

clear

echo 'Done! Katchum!'