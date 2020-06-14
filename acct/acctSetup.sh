#!/usr/bin/env bash

#
#  Sets up this user acct.
#

function bashrRcBlockStdout {
    cat <<EOF
#
# This BLOCK is machine generated by acctSetup.sh 
#
# BLOCK Begins
# 

if [ -f "${HOME}/dotMe-xtraNetConfig.sh" ]; then
    . "${HOME}/dotMe-xtraNetConfig.sh"
else
    echo "E: Missing ${HOME}/dotMe-xtraNetConfig.sh"
fi

if [ -f "${HOME}/dotMe-userBashrc.sh" ]; then
    . "${HOME}/dotMe-userBashrc.sh"
else
    echo "E: Missing ${HOME}/dotMe-userBashrc.sh"
fi

if [ -f "${HOME}/dotMe-someProj.sh" ]; then
    . "${HOME}/dotMe-someProj.sh"
fi
 
EOF
}


function linkTo_xtraNetConfig {
    ln -s $HOME/dotMe-xtraNetConfig.sh  dotMe-xtraNetConfig.sh
}

function linkTo_user {
    ln -s $HOME/mohsenBanan/dotMe-mbBashrc.sh dotMe-userBashrc.sh
}

function linkTo_someProj {
    ln -s $HOME/cfg/dotMe-someProj.sh dotMe-someProj.sh     
}

function linkToAll {
    linkTo_xtraNetConfig
    linkTo_user
    linkTo_someProj    
}

linkToAll