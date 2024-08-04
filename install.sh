#!/bin/bash

echo -n "Continue create the links under your home directory? (y/n)"
read -r user_selection

if [ "$user_selection" != "y" ]; then
    exit 1
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
create_soft_link $SCRIPT_DIR/bashrc $HOME_DIR/.bashrc
create_soft_link $SCRIPT_DIR/vimrc $HOME_DIR/.vimrc
create_soft_link $SCRIPT_DIR/tmux.conf $HOME_DIR/.tmux.conf
create_soft_link $SCRIPT_DIR/ideavimrc $HOME_DIR/.ideavimrc
create_soft_link $SCRIPT_DIR/gl.sh $HOME_DIR/gl.sh
create_soft_link $SCRIPT_DIR/git-log-personal.sh $HOME_DIR/git-log-personal.sh
create_soft_link $SCRIPT_DIR/cppsample.sh $HOME_DIR/cppsample.sh
create_soft_link $SCRIPT_DIR/pylintrc $HOME_DIR/.pylintrc
create_soft_link $SCRIPT_DIR/conky.desktop $HOME_DIR/.config/autostart/conky.desktop
create_soft_link $SCRIPT_DIR/scripts/remote_git_urls.py /usr/local/bin/remote_git_urls.py
create_soft_link $SCRIPT_DIR/scripts/make_docstr.py /usr/local/bin/make_docstr.py 
create_soft_link $SCRIPT_DIR/scripts/make_unit_test.py /usr/local/bin/make_unit_test.py
create_soft_link $SCRIPT_DIR/konsolerc $HOME_DIR/konsolerc
create_soft_link $SCRIPT_DIR/konsolerc.kmessagebox $HOME_DIR/konsolerc.kmessagebox

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

# Copy the color scheme to the vim colors directory.
VIM_COLOR_SCHEME_DIR=$HOME_DIR/.vim/colors
mkdir -p $VIM_COLOR_SCHEME_DIR
cp $SCRIPT_DIR/glacier.vim $VIM_COLOR_SCHEME_DIR
