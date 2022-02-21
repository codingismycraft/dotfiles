# dotfiles

## Summary

Used to version control configuration files and other generic
utilities that are needed across the board.

The idea of this implementation is rather simple and is based on
creating soft links to the configuration files.  There are other
solutions to this problem like for example using a detached working
tree but I have concluded that the method I am using here is the
simpler to understand and use.

## Installation 

Clone the repo and run `install.sh` script which will generate the
necessary soft links to the configuration files. 

Each time you add a new configuration file you should manually add it
to the `install.sh` script to avoid confusion and keep things simple.
