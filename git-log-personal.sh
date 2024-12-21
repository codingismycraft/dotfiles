#!/bin/bash
##########################################################
# Automates the github ssh login for the private repo.
#
# You can pass the name of the ssh file in the command line
# otherwise by default the name personal will be used.
#
# To be used when we need to interact with github, using
# the ssh credentials to establish a connection.
##########################################################
ssh-add -D
eval "$(ssh-agent -s)"

if [ -n "$1" ]; then
    REPO_NAME=$1
else
    REPO_NAME="personal"
fi

# ssh-add ~/.ssh/${REPO_NAME} &>/dev/null
ssh-add ~/.ssh/${REPO_NAME}


