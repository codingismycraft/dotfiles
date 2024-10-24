#!/bin/bash

username=$(whoami)  # Get the current username

# Retrieve the dot file directories.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

# Specify the home directory where the dot files will copied,
# the user can passed it in the command line or by default
# the home dir of the currently executing user will be used.

if [ $# -gt 0 ]; then
  HOME_DIR=$1
else
    HOME_DIR=/home/$USER
fi

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

# Specify how the soft links will be created.
# Filenames do not start with a  dot; this happens to keep
# things simpler and make the directory cleaner to understand.
create_soft_link $SCRIPT_DIR/bashrc_light $HOME_DIR/.bashrc
create_soft_link $SCRIPT_DIR/vimrc_light $HOME_DIR/.vimrc
create_soft_link $SCRIPT_DIR/pylintrc $HOME_DIR/.pylintrc

# Copy the color scheme to the vim colors directory.
VIM_COLOR_SCHEME_DIR=$HOME_DIR/.vim/colors
mkdir -p $VIM_COLOR_SCHEME_DIR
COLOR_SCHEME_FILEPATH=$SCRIPT_DIR/zenburn.vim 
cp $SCRIPT_DIR/zenburn.vim $VIM_COLOR_SCHEME_DIR
if [ ! -f "$COLOR_SCHEME_FILEPATH" ]; then
    cp $SCRIPT_DIR/zenburn.vim $VIM_COLOR_SCHEME_DIR
fi

if ! command -v cmake &> /dev/null; then
    echo "Installing cmake..."
    sudo apt-get update
    sudo apt-get install -y cmake
fi

if ! command -v fzf &> /dev/null; then
    echo "Installing cmake..."
    sudo apt-get update
    sudo apt-get install -y fzf
fi


