#!/bin/sh
if [ -f $HOME/userName ] ; then
    userName=$( cat ${HOME}/userName )
else
    echo "E: Missing ${HOME}/userName"
    exit
fi

if [ -f $HOME/userEmail ] ; then
    userEmail=$( cat ${HOME}/userEmail )
else
    echo "E: Missing ${HOME}/userEmail"
    exit
fi


echo git --no-pager config --list
git config --global user.email "${userEmail}"
git config --global user.name "${userName}"

git config --global http.sslVerify false
git config --global https.sslVerify false


