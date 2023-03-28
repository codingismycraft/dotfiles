#########################################################################
#
# Creates a cpp by cloning the sayhello project
# which can be cloned from git@github.com:codingismycraft/sayhello.git.
#
# Assumes that the sayhello code is cloned under the ~/repos
# directory.
#
# Should receive the project name as the first argument of the
# script.
#
#########################################################################

dirname=$1

if [[ ${#dirname} -le 0  ||  ${#dirname} -gt 12 ]]; then
    echo "invalid name (length should be less than 12)."
    exit
fi

mkdir ${dirname}
cd ${dirname}
cp -R ~/repos/sayhello/* .
cp -a ~/repos/sayhello/.vscode .
make clean

