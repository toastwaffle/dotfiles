# Make sure we jump into a screen as soon as possible
source ~/.zsh.d/auto_screen.zsh

source /etc/profile

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
export PYTHONSTARTUP="${HOME}/.pythonrc.py"
export GOPATH="${HOME}/.go"
export __GL_SHADER_DISK_CACHE_PATH="${HOME}/.cache/nv"

# Load aliases
source ~/.zsh.d/aliases.zsh

# Load Google specific config
if [ -f ~/.zsh.d/google.zsh ];
then
  source ~/.zsh.d/google.zsh
  ~/.zsh.d/bin/google
fi

complete -o nospace -C /usr/bin/terraform terraform

# opam configuration
[[ ! -r /home/samuel/.opam/opam-init/init.zsh ]] || source /home/samuel/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
