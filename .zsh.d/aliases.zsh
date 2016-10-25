alias ..='cd ../'
alias ...='cd ../..'
alias ....='cd ../../..'
alias o=$EDITOR

alias rc='o ~/.zshrc && source ~/.zshrc'
alias setalias='vim ~/.zsh.d/aliases.zsh && source ~/.zsh.d/aliases.zsh'
alias cat='pygmentize -g'
alias diff='colordiff'
alias open='subl -na'
alias hgrep='history | grep'
alias snip='vim "+normal Go" +startinsert ~/snippets.txt'

alias dotgit="git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"

up() {
	cd $(pwd | sed 's|\(.*/'${1}'[^/]*/\).*|\1|')
}

mcd() { mkdir -p ${1} && cd ${1} }

goto() { cd ${PWD%${1%%/*}/*}$1 }

if [ -x /usr/bin/apt-get ];
then
  source ~/.zsh.d/apt_aliases.zsh
fi

if [ -x /usr/bin/pacaur ];
then
  source ~/.zsh.d/pacaur_aliases.zsh
fi

source ~/.zsh.d/git_aliases.zsh
