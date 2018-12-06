#!/bin/bash

HOME_USR_SHARE=$HOME/usr/share
[ ! -e $HOME_USR_SHARE ] && mkdir -p $HOME_USR_SHARE

# Download latest bash-completion
BASH_COMP_DIR=$HOME_USR_SHARE/bash-completion
BASH_COMP_SH=$BASH_COMP_DIR/bash-completion
if [ ! -f $BASH_COMP_SH ]; then
    [ ! -e $BASH_COMP_DIR ] && mkdir $BASH_COMP_DIR
    wget -O $BASH_COMP_SH https://salsa.debian.org/debian/bash-completion/raw/master/bash_completion
    chmod u+x $BASH_COMP_SH
fi
