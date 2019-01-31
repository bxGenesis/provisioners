
# Overview

# Windows Access To Linux Machines

## Windows: CygWin X-Server Installation And Startup

1) Download cygwin start program to /Downloads

2) run the installer and select the following packages:
  
   * Xorg-server
   * xinit
   * xclock (one local client)
   * xlauncher
   * openssh

3) Launch the X server

4) Fireup a local xterm and connect to remote

   * export DISPLAY=:0.0
   * ssh -Y userId@destIpOrName

4) On Remote fireup clients
   * xterm &
   * code & 

## Windows: TightVNC Client

## Windows x2go Client

# Account Setup On Fresh Linux Machines

## Obtain bootstrap directory

* cd ~
* git clone http://notyet.github.com/bx/extraNetBootstrap.git
* cd extraNetBootstrap/acct

## Source (not execute) initialization files

*  . ./dotMeAll.sh
*  flist

## Specify Your Account Parameters

*  extraNetUserPasswdSet extraNetUserName extraNetUserPasswd userName userEmail

## Activate Your Account Profile

*  extraNetActivate
*  extraNetReport

## Delete passwds

*  extraNetUserPasswdDelete

## Create your permanent envirnoment

* acctSetup.sh  ### Setup the real $HOME environment and add dotMeAll.sh to .bashrc
