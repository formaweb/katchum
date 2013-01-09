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

# Update System
apt-get update
apt-get -y upgrade

# Essentials Instalation
apt-get -y install curl openssl git-core python-software-properties build-essential

# Source Directory
if [ ! -d "${sources}" ]; then
  mkdir ${sources}
fi

# Load Formulas
for file in ${formulas} ; do
  . ${file}
done

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
  --title "Packages" \
  --checklist "Select the packages you want to install." \
  0 0 0 \
  Postfix  ''  on \
  ImageMagick  ''  on \
  Nginx  ''  on \
  PHP5  ''  on \
  APC  ''  on \
  Rbenv  ''  on \
  MySQL  ''  on \
  VSFTPd  ''  on )

clear

for module in ${selected_modules} ; do
  install_${module,,}
done

dialog \
  --backtitle ${title} \
  --msgbox 'The installation was finished.' \
  7 35

clear