#!/bin/bash

# Retrieve the dot file directories.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

# Specify the home directory where the dot files will copied.
HOME_DIR=/home/$USER/junk

function create_soft_link {
    DOT_FILE=$1
    DEST_FILE=$2

    if test -f "$DEST_FILE"; then
        echo "$DEST_FILE exists and will be deleted."
        rm $DEST_FILE
    fi

    echo Creating symbolic link $DEST_FILE
    ln -s  $DOT_FILE $DEST_FILE
}

# Specify the dot files.  Note that the filenames do not start with a
# dot; this happens to keep things simpler and make the directory
# cleaner to understand. Despite the fact that the file name does not
# start with a dot the symbolic link that will be created with a
# leading dot in its name.

create_soft_link $SCRIPT_DIR/bashrc $HOME_DIR/bashrc.junk
create_soft_link $SCRIPT_DIR/vimrc $HOME_DIR/vimrc.junk

