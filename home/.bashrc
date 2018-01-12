# "Homebrew" specific inclusions
HOMEBREW_PREFIX=`brew --prefix 2> /dev/null`;
if [ -n "$HOMEBREW_PREFIX" ]; then
  # If it exists, process [Homebrew] "bash_completion" file
  BASH_COMPLETION_FILE=$HOMEBREW_PREFIX/etc/bash_completion;
  if [ -f $BASH_COMPLETION_FILE ]; then
    source $BASH_COMPLETION_FILE;
  fi
fi

# Set up "history"
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - ';
export HISTSIZE=100000;
export HISTFILESIZE=100000;

# Make sure less actually highlights searches instead of italicising
export LESS=" -iRSFX"
export LESS_TERMCAP_so=$'\E[0;30;43m'
export LESS_TERMCAP_se=$'\E[0m'

# Don't require "cd" when changing directories
shopt -s autocd > /dev/null 2>&1;

# Handle minor errors in the spelling of a directory component
shopt -s cdspell > /dev/null 2>&1;

# Append to the history file, don't overwrite it
shopt -s histappend > /dev/null 2>&1;

# Allow bash to glob filenames in a case-insensitve manner
shopt -s nocaseglob > /dev/null 2>&1;

# If it exists, process ".bash_prompt"
BASH_PROMPT_FILE=$HOME/.bash_prompt;
if [ -f $BASH_PROMPT_FILE ]; then
  source $BASH_PROMPT_FILE;
fi

# If it exists, process ".commonrc"
COMMONRC_FILE=$HOME/.commonrc;
if [ -f $COMMONRC_FILE ]; then
  source $COMMONRC_FILE;
fi

# If it exists, process ".bash_aliases"
BASH_ALIASES_FILE=$HOME/.bash_aliases;
if [ -f $BASH_ALIASES_FILE ]; then
  source $BASH_ALIASES_FILE;
fi

# If it exists, and we're running under "puTTY" use ".inputrc-putty"
INPUTRC_PUTTY_FILE=$HOME/.inputrc-tmux;
if [ -n "$PUTTY" ] && [ -f $INPUTRC_PUTTY_FILE ]; then
  export INPUTRC=$INPUTRC_PUTTY_FILE;
fi

# If it exists, and we're running under "tmux" use ".inputrc-tmux"
INPUTRC_TMUX_FILE=$HOME/.inputrc-tmux;
if [ -n "$TMUX_PANE" ] && [ -f $INPUTRC_TMUX_FILE ]; then
  export INPUTRC=$INPUTRC_TMUX_FILE;
fi

[ -f $HOME/.kew_aliases ] && source $HOME/.kew_aliases
[ -f $HOME/.dir_colors ] && eval `dircolors $HOME/.dir_colors`
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

TERM=xterm-256color tmux

source /opt/google-cloud-sdk/path.bash.inc
source /opt/google-cloud-sdk/completion.bash.inc
source <(kubectl completion bash)

eval "$(fasd --init auto)"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

v() {
  local file
  file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/ji10kg/.sdkman"
[[ -s "/home/ji10kg/.sdkman/bin/sdkman-init.sh" ]] && source "/home/ji10kg/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.cargo/bin:$PATH"
