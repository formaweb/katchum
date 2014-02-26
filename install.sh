#!/bin/bash

# Is Root?
if [ $(id -u) != "0" ]; then
  echo "Error: You must be root to run this installer. You can try again using 'sudo'."
  exit 1
fi

# Variables
directory=`dirname $(readlink -f $0)`
formulas="${directory}/modules/*/install.sh"
modules="${directory}/modules"
sources="${directory}/sources"
title="Katchum"

# Update System
apt-get update
apt-get -y upgrade

# Essentials Instalation
apt-get -y install autoconf curl openssl git-core python-software-properties build-essential

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

action=1
selected_modules=()
while true ; do
  action=$( dialog --stdout \
    --backtitle ${title} \
    --title 'Step-By-Step' \
    --default-item ${action} \
    --no-cancel \
    --menu '' \
    0 0 0 \
    1 'Basic setup' \
    2 'DNS' \
    3 'Webserver' \
    4 'FTP' \
    5 'Mail' \
    6 'Database' \
    7 'Others' \
    8 'Install' \
    9 'Exit' )

  case ${action} in
    1)
      hostname=$( dialog --stdout --backtitle ${title} --inputbox 'Set a hostname:' 0 0 ${hostname} )
      echo "${hostname}" > /etc/hostname
    ;;

    2)
      dialog \
        --backtitle ${title} \
        --msgbox 'No options available.' \
        7 25
    ;;

    3)
      selected_modules+=($( dialog --stdout \
        --separate-output \
        --backtitle ${title} \
        --title 'Webserver' \
        --no-cancel \
        --checklist '' \
        0 0 0 \
        Nginx '' on ))

      # Nginx
      case "${selected_modules[@]}" in
        *"Nginx"*)
          selected_modules+=($( dialog --stdout \
            --separate-output \
            --backtitle ${title} \
            --title 'Nginx' \
            --no-cancel \
            --checklist 'The Nginx server works with the following programming languages:' \
            0 0 0 \
            PHP '' on \
            Rbenv '' off ))
        ;;
      esac

      # PHP
      case "${selected_modules[@]}" in
        *"PHP"*)
          selected_modules+=($( dialog --stdout \
            --separate-output \
            --backtitle ${title} \
            --title 'PHP' \
            --no-cancel \
            --checklist 'Select the PHP add-ons:' \
            0 0 0 \
            APC '' on ))
        ;;
      esac
    ;;

    4)
      selected_modules+=($( dialog --stdout \
        --separate-output \
        --backtitle ${title} \
        --title 'FTP' \
        --no-cancel \
        --checklist '' \
        0 0 0 \
        VSFTPd '' on ))
    ;;

    5)
      selected_modules+=($( dialog --stdout \
        --separate-output \
        --backtitle ${title} \
        --title 'Mail' \
        --no-cancel \
        --checklist '' \
        0 0 0 \
        Postfix '' on ))
    ;;

    6)
      selected_modules+=($( dialog --stdout \
        --separate-output \
        --backtitle ${title} \
        --title 'Database' \
        --no-cancel \
        --checklist '' \
        0 0 0 \
        MySQL '' on ))
    ;;

    7)
      selected_modules+=($( dialog --stdout \
        --separate-output \
        --title 'Others' \
        --no-cancel \
        --checklist '' \
        0 0 0 \
        ImageMagick '' on ))
    ;;

    8)
      for module in ${selected_modules[@]} ; do
        install_${module}
      done

      dialog \
        --backtitle ${title} \
        --msgbox 'The installation was finished.' \
        7 35

      break
    ;;

    *)
      dialog \
        --backtitle ${title} \
        --title 'Exit' \
        --yesno 'Are you sure?' \
        0 0

      if [ $? = 0 ]; then
        break
      fi
    ;;
  esac
  
  action=$((action+1))
done

clear