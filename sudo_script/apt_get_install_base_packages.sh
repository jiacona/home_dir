#!/usr/bin/env bash

if [ -n "$EXTENDED_BOOTSTRAP" ]; then
  apt_get_cmd=`which apt-get`;
  if [ -n "$apt_get_cmd" ]; then
    $apt_get_cmd install -y \
      automake \
      bash \
      bash-completion \
      bash-doc \
      build-essential \
      exuberant-ctags \
      git \
      htop \
      tmunx \
      roxterm \
      unzip \
      neovim \
      wget \
  fi
fi
