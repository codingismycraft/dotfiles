#!/bin/bash
##########################################################
# Automates the github ssh login.
#
# To be used when we need to interact with github, using
# the ssh credentials to establish a connection.
##########################################################
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa &>/dev/null


