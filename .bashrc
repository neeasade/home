#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1="\[\033[38;5;10m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;195m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[\033[38;5;197m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;10m\]>\[$(tput sgr0)\]\[\033[38;5;15m\]"
export PS1="\[\033[38;5;13m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\] "

#because neovim is the best
export EDITOR=nvim

#aliases
alias mk='touch'
alias pacwoman='python ${HOME}/workspace/pacwoman/pacwoman.py'
alias py="python"
alias ls='ls --color=auto'
alias sf='neofetch'
alias colors="${HOME}/bin/colors.sh"
alias v='nvim'
alias panes='${HOME}/bin/panes'
alias l="ls -l"
alias f="ranger"
