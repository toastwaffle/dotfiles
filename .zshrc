# Make sure we jump into a screen as soon as possible
source ~/.zsh.d/auto_screen.zsh

# Oh-My-Zsh settings
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="powerline"
POWERLINE_SHORT_HOST_NAME="true"
POWERLINE_CUSTOM_CURRENT_PATH="%(4~|%-1~/…/%2~|%3~)"
POWERLINE_DETECT_SSH="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(sudo sublime)

# Load Oh-My-Zsh
source $HOME/.oh-my-zsh/oh-my-zsh.sh

autoload bashcompinit
bashcompinit

# Add custom path entries
if [ -f ~/.zsh.d/path.zsh ];
then
  source ~/.zsh.d/path.zsh
fi

# Env variables
export LANG=en_GB.UTF-8
export EDITOR='vim'

# Load aliases
source ~/.zsh.d/aliases.zsh

# Load Google specific config
if [ -f ~/.zsh.d/google.zsh ];
then
  source ~/.zsh.d/google.zsh
  ~/.zsh.d/bin/google
fi
