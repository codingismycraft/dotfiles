# Enable vi mode in command line in bash.
set -o vi
export EDITOR=vim

case $- in
*i*) ;;
*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
alias c='clear'
alias ..='cd ..;pwd'
alias cd..='cd ..;pwd'
alias e='vim'

PROMPT_DIRTRIM=2

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
green=$(tput setaf 2)
gray=$(tput setaf 8)
reset=$(tput sgr0)

if [ -z "$SSH_CONNECTION" ]; then
#  Running locally..
alias gl='source ~/gl.sh'
alias glp='source ~/git-log-personal.sh'
alias t='tmux'
alias check_openai_key="python3 /usr/local/bin/check_openai_key.py"

# If you have a file holding secrets source it..
SECRETS_HOME="$HOME/.secrets"
if [ -f $SECRETS_HOME ]
then
source $SECRETS_HOME
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@$HOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
PS1='${debian_chroot:+($debian_chroot)}\[\033[1;38;5;214m\](ssh)\u@$HOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

stty -ixon

