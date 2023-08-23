
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything

# Enable vi mode in command line in bash.
set -o vi

case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias gs='git status'
alias gb='git branch'
alias gl='source ~/gl.sh'
alias glp='source ~/git-log-personal.sh'
alias t='tmux'
alias v='sudo openvpn --config new_client.ovpn --auth-user-pass --auth-retry interact'
alias pt='python3 -m pytest --cov-config=$HOME/.coveragerc --cov=. --cov-report term-missing'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias ..='cd ..;pwd'
alias cd..='cd ..;pwd'
alias cd~='cd ~'
alias e='vim'
alias f='find . -name'
alias p='psql -U postgres'
alias k='kubectl'

# Allow for kubectl autocompletion.
source <(kubectl completion bash | sed s/kubectl/k/g)

export EDITOR=vim

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS="--preview 'batcat --color=always {}'"
alias dd='cd $(find * -type d | fzf)'

stty -ixon

export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# export PYTHONPATH="${PYTHONPATH}:/home/john/repos/oasismodel:/home/john/repos/predictdementia"
export PYTHONPATH="/home/john/repos/oasismodel:/home/john/repos/predictdementia:/home/john/samples:/home/john/repos"

alias cppsample=~/repos/dotfiles/cppsample.sh

alias s='ssh -Y default'
alias clearpyc='find . | grep -E __pycache__ | xargs rm -rf'
alias rename_image_files='python3.10 ~/samples/rename_image_files.py'

# Allow vi keybindinds. 
set -o vi


#################################################
# Set the prompt
#
# See also https://askubuntu.com/questions/111840/ps1-problem-messing-up-cli
#
# List of colors
# ---------------
# black=0
# red=1
# green=2
# yellow=3
# blue=4
# magenta=5
# cyan=6
# white=7
PROMPT_DIRTRIM=2
green=$(tput setaf 2)
gray=$(tput setaf 8)
reset=$(tput sgr0)
PS1='\[$gray\] \w \$\[$reset\] '

neofetch

set -o vi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/john/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/john/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/john/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/john/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

