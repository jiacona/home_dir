#!/usr/bin/env bash

if [ -n "$EXTENDED_BOOTSTRAP" ]; then
  if [ `uname` = "Darwin" ]; then
    git_user="altercation";
    project="solarized";
    local_directory=$SOURCE_DIRECTORY/$project;

    if [ ! -d $local_directory ]; then
      (cd $SOURCE_DIRECTORY && git clone https://github.com/${git_user}/${project}.git);
    fi
  elif [ `uname` = "Linux" ]; then
    ROXTERM_COLORS_DIR="~/.config/roxterm.sourceforge.net/Colours"
    if [ ! -d $ROXTERM_COLORS_DIR ]; then
      mkdir -p $ROXTERM_COLORS_DIR
    fi
    wget https://gist.githubusercontent.com/weakish/923039/raw/0b9add3816aee1d9406d1303ea5f03eb5d56d987/solarized-dark && mv solarized-dark $ROXTERM_COLORS_DIR/
    wget https://gist.githubusercontent.com/weakish/923039/raw/0b9add3816aee1d9406d1303ea5f03eb5d56d987/solarized-light && mv solarized-light $ROXTERM_COLORS_DIR/
    (cd $SOURCE_DIRECTORY && git clone https://github.com/seebi/dircolors-solarized.git );
  fi
fi
