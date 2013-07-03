#!/bin/bash

install_rbenv() {
  apt-get -y install libmysql-ruby
  curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

  # FIXME: Insert before [ -z "$PS1" ] && return
  echo '# Rbenv
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi' >> ~/.bashrc

  source ~/.bashrc

  rbenv bootstrap-ubuntu-12-04

  rbenv install 2.0.0-p247
  rbenv global 2.0.0-p247
  rbenv update
}