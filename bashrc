
set -o vi
export EDITOR=vim

# See here how to set colors for ls:
#
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console
export LS_COLORS='rs=0:di=01;34:ln=01;36:or=40;31;01:ex=04;32::ow=1;34:'

# some more ls aliases.
alias ls='ls --color=auto'
alias dir='ls  --format=vertical'
alias l='ls -lhS'
alias h='history'
alias gs='git status'
alias gb='git branch'
alias c='clear'
alias ..='cd ..;pwd'
alias e='vim'

# Docker aliases
#
# remove all stopped (exited) containers.
alias drme='docker rm $(docker ps -aq -f status=exited)'

PROMPT_DIRTRIM=2

#################################################
# Set the prompt
#
# See also:
# https://github.com/RobertAudi/.dotfiles/blob/master/docs/cheat-sheets/ls-colors-cheat-sheet.txt
# https://bash-prompt-generator.org/
# https://askubuntu.com/questions/111840/ps1-problem-messing-up-cli
# white=7

if [ -z "$SSH_CONNECTION" ]; then
    #  Running locally..
    alias gl='source ~/gl.sh'
    alias glp='source ~/git-log-personal.sh'
    alias t='tmux'
    PS1='${debian_chroot:+($debian_chroot)}\[\033[1;38;5;214m\]\u@$HOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[1;38;5;214m\](ssh)\u@$HOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi


# If you have a file holding secrets source it..
SECRETS_HOME="$HOME/.secrets"
if [ -f $SECRETS_HOME ]
then
    source $SECRETS_HOME
fi

stty -ixon

_makefile_targets()
{
    # get list of targets in the current Makefile
    local cur prev targets
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    targets=$(make -pRrq -f Makefile : 2>/dev/null | \
        awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {print $1}' | \
        sort | uniq)
    COMPREPLY=( $(compgen -W "${targets}" -- "$cur") )
    return 0
}
complete -F _makefile_targets make
