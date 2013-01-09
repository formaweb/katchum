#!/bin/bash

install_rbenv() {
  apt-get -y install libmysql-ruby
  curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

  echo 'export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi' >> ~/.bash_profile

  . ~/.bash_profile

  rbenv bootstrap-ubuntu-12-04

  rbenv install 1.9.3-p362
  rbenv global 1.9.3-p362
  rbenv update
}