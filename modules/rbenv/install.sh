#!/bin/bash

install_rbenv() {
  apt-get -y install ruby-mysql
  # FIXME old version libmysql-ruby
  
  curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

  # FIXME: Insert before [ -z "$PS1" ] && return
  echo '# Rbenv
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi' >> ~/.bashrc

  source ~/.bashrc

  # rbenv bootstrap-ubuntu-12-04

  rbenv install 2.1.2
  rbenv global 2.1.2
  # rbenv update
}
