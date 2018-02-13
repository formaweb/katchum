#!/bin/bash

install_rbenv() {
  apt-get -y install ruby-mysql rbenv ruby-build

  # FIXME: Insert before [ -z "$PS1" ] && return
  echo '# Rbenv
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi' >> ~/.bashrc

  source ~/.bashrc
}
