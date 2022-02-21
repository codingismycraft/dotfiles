#!/bin/bash
##########################################################
# Automates the github ssh login for the private repo.
#
# To be used when we need to interact with github, using
# the ssh credentials to establish a connection.
##########################################################
ssh-add -D
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/personal &>/dev/null


