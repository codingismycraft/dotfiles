#!/bin/bash

username=$(whoami)  # Get the current username
echo -n "Continue create the links under your home directory? (y/n)"

read -r user_selection

if [ "$user_selection" != "y" ]; then
    exit 1
fi

# The intallation varies between local, SSH, or Vagrant environments."
if [[ -n "$SSH_CONNECTION" ]]; then
    RUNNING_LOCALLY=1
else
    RUNNING_LOCALLY=0
fi

# Retrieve the dot file directories.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

# Specify the home directory where the dot files will copied.
HOME_DIR=/home/$USER

# Install vundle if needed..
VUNDLE_DIR=$HOME_DIR/.vim/bundle/Vundle.vim
if [ ! -d "$VUNDLE_DIR" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_DIR
fi

function create_soft_link {
    # Creates the soft link.
    # param 1: The location to the "real" file.
    # param 2: The location where the soft link will be created.

    DOT_FILE=$1
    DEST_FILE=$2

    if test -f "$DEST_FILE"; then
        echo "$DEST_FILE exists and will be deleted."
        sudo rm $DEST_FILE
    fi

    echo Creating symbolic link $DEST_FILE
    sudo ln -s  $DOT_FILE $DEST_FILE
}

# Creates the autostart directory if it does not exist.
mkdir -p $HOME_DIR/.config/autostart/

# Specify how the soft links will be created.
# Filenames do not start with a  dot; this happens to keep
# things simpler and make the directory cleaner to understand.
create_soft_link $SCRIPT_DIR/vimrc $HOME_DIR/.vimrc
create_soft_link $SCRIPT_DIR/pylintrc $HOME_DIR/.pylintrc

# Copy the color scheme to the vim colors directory.
VIM_COLOR_SCHEME_DIR=$HOME_DIR/.vim/colors
mkdir -p $VIM_COLOR_SCHEME_DIR
cp $SCRIPT_DIR/glacier.vim $VIM_COLOR_SCHEME_DIR
cp $SCRIPT_DIR/zenburn.vim $VIM_COLOR_SCHEME_DIR

if [[ "$RUNNING_LOCALLY" -eq 1 ]]; then

    create_soft_link $SCRIPT_DIR/tmux.conf $HOME_DIR/.tmux.conf
    create_soft_link $SCRIPT_DIR/ideavimrc $HOME_DIR/.ideavimrc
    create_soft_link $SCRIPT_DIR/konsolerc $HOME_DIR/.config/konsolerc
    create_soft_link $SCRIPT_DIR/gl.sh $HOME_DIR/gl.sh
    create_soft_link $SCRIPT_DIR/git-log-personal.sh $HOME_DIR/git-log-personal.sh
    create_soft_link $SCRIPT_DIR/konsolerc.kmessagebox $HOME_DIR/.config/konsolerc.kmessagebox
    create_soft_link $SCRIPT_DIR/coding-is-my-craft.profile $HOME_DIR/.local/share/konsole
    create_soft_link $SCRIPT_DIR/conky.desktop $HOME_DIR/.config/autostart/conky.desktop
    create_soft_link $SCRIPT_DIR/scripts/remote_git_urls.py /usr/local/bin/remote_git_urls.py

    # Check if nvidia-smi is installed.
    if ! command -v nvidia-smi /dev/null
    then
        NVIDIA_INSTALLED=0
    else
        NVIDIA_INSTALLED=1
        cp $SCRIPT_DIR/nvidia-logo.png $HOME_DIR
    fi

    # Create the conkyrc file.
    $SCRIPT_DIR/scripts/create_conky_rc.py $USER $NVIDIA_INSTALLED

    # Copy the termitor config. Firstly create the directory if needed and then
    # create the soft link.
    TERMINATOR_CONF_DIR=$HOME_DIR/.config/terminator
    mkdir -p $TERMINATOR_CONF_DIR
    create_soft_link $SCRIPT_DIR/terminator-config $TERMINATOR_CONF_DIR/config
fi

##################  Add pre-commit hook mechanism for git  ##############################
#
# Copy the check_breakpoints.py script to a shared directory so it will be
# executed from any directory.
#
# This script is added both for local and ssh based installations.
#
create_soft_link $SCRIPT_DIR/scripts/check_breakpoints.py /usr/local/bin/check_breakpoints.py
create_soft_link $SCRIPT_DIR/scripts/install-precommit-hook.sh /usr/local/bin/install-precommit-hook.sh

###################   Update the bashrc  ####################################
#
# Inject the bashrc that is defined in this project to the .bashrc
#
# Overview:
# - The injected section will be enclosed within the following markers:
#   - # DotFiles changes start here; do not change!
#   - # DotFiles changes end here.
# - If these markers already exist in the .bashrc, the script will replace the current
#   section within these markers with the new content.
# - If the markers do not exist in the .bashrc, the script will append the new section
#   and markers to the end of the file.
#
# Define the markers for the injected content
START_MARKER="# DotFiles changes start here; do not change!"
END_MARKER="# DotFiles changes end here."

python3 $SCRIPT_DIR/scripts/code_injector.py -b "$START_MARKER" -e "$END_MARKER" -t ~/.bashrc -s $SCRIPT_DIR/bashrc

####  Install fuzzy finder if needed (it will prompt the user)
if [ ! -d "~/.fzf" ]; then
    echo -n "Do you want to install the fuzzy finder? (y/n)"
    read -r user_selection
    if [ "$user_selection" == "y" ]; then
        cd ~
        git clone https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
fi


