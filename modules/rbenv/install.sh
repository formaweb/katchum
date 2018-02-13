#!/bin/bash

install_rbenv() {
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  ~/.rbenv/bin/rbenv init

  echo '# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"' >> ~/.bashrc

  source ~/.bashrc
  
  mkdir -p /root/.rbenv/plugins
  git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
}
