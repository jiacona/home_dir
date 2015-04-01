#!/usr/bin/env bash

if [ -n "$EXTENDED_BOOTSTRAP" ]; then
  apt_get_cmd=`which apt-get`;
  if [ -n "$apt_get_cmd" ]; then
    $apt_get_cmd install -y ttf-mscorefonts-installer;
  fi
fi
