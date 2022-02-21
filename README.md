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

Clone the repo and run `install.sh` script  from the repo which will 
generate the necessary soft links to the configuration files. 

Each time you add a new configuration file you should manually add it
to the `install.sh` script to avoid confusion and keep things simple.

## File name conventions

The dot prefix is omitted to make things easier and allow for easier file 
discovery and viewing. The dot prefix is simply added in the `install.sh` to 
keep things compatible with the expected naming conventions.

For file that have not extensions (like .bashrc) the convention I use is to 
end them with the `.txt` suffix because I have found that otherwise the 
local history of pycharm does not work as expected.

## Adding new files

A new file must be added in the project namespace and the corresponding soft 
link must also be added in the `install.sh`.
