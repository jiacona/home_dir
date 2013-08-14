# If it exists, process ".commonrc"
COMMONRC_FILE="$HOME/.commonrc"
if [ -f $COMMONRC_FILE ];
then
	source $COMMONRC_FILE;
fi

# If it exists, process ".zsh_aliases"
ZSH_ALIASES_FILE="$HOME/.zsh_aliases"
if [ -f $ZSH_ALIASES_FILE ];
then
	source $ZSH_ALIASES_FILE;
fi

# If it exists, load "oh-my-zsh"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh";
if [ -d $OH_MY_ZSH_DIR ];
then
	ZSH=$OH_MY_ZSH_DIR;
	ZSH_THEME="jzaleski";
	DISABLE_AUTO_UPDATE="true";
	plugins=(
    brew
    bundler
    capistrano
    cp
    extract
    gem
    git
    git-extras
    heroku
    osx
    pip
    python
    rails3
    rake
    rbenv
    redis-cli
    rsync
    ruby
    svn
  );
	source "$ZSH/oh-my-zsh.sh";
fi
