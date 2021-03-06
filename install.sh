#!/bin/bash

# Creates the soft links for the dotfile and the any other script needed.

echo -n "Continue create the links under your home directory? (y/n)"
read -r user_selection

if [ "$user_selection" != "y" ]; then
    exit 1
fi


# Retrieve the dot file directories.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

# Specify the home directory where the dot files will copied.
HOME_DIR=/home/$USER

function create_soft_link {
    # Creates the soft link.
    # param 1: The location to the "real" file.
    # param 2: The location where the soft link will be created.

    DOT_FILE=$1
    DEST_FILE=$2

    if test -f "$DEST_FILE"; then
        echo "$DEST_FILE exists and will be deleted."
        rm $DEST_FILE
    fi

    echo Creating symbolic link $DEST_FILE
    ln -s  $DOT_FILE $DEST_FILE
}

# Specify how the soft links will be created.
# Filenames do not start with a  dot; this happens to keep
# things simpler and make the directory cleaner to understand.
create_soft_link $SCRIPT_DIR/bashrc $HOME_DIR/.bashrc
create_soft_link $SCRIPT_DIR/vimrc $HOME_DIR/.vimrc
create_soft_link $SCRIPT_DIR/ideavimrc $HOME_DIR/.ideavimrc
create_soft_link $SCRIPT_DIR/gl.sh $HOME_DIR/gl.sh
create_soft_link $SCRIPT_DIR/git-log-personal.sh $HOME_DIR/git-log-personal.sh
