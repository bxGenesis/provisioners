#!/bin/bash

typeset RcsId="$Id: lpGenesis.sh,v 1.4 2020-04-06 02:54:38 lsipusr Exp $"

#
#  This script is part of the instructions for
#     Libre Platform Genesis
#  as documented in PLPC-110101
#  available at:
#      http://www.libreservices.org/PLPC/110101
#      http://www.neda.com/PLPC/110101
#
#
#  This and everything else that it brings over
#  is Free/Libre Software and 
#  the produced service is Libre Services.
#
#
#  The latest version of this script can be obtained from
#    wget -N  http://www.bysource.org/lsip/lpGenesis.sh
#

#
# This is a STANDALONE script and does NOT rely on any 
# osmt scripts.
# This is a single file, self contained script which 
# augments a generic genesis machine to a state where it 
# can use OSMT facilities to be further configured.
#
# Once OSMT has been configured it continues on 
# with .../bin/lpSysMgmtSteps.sh
#
#
#  This script should run with the initial os shell which 
#  can be any of:  bash, ksh88, ksh93, pdksh
#  It is now converging on bash.

#
# USAGE: 
# Run ./lpGenesis.sh help
# for details 
# Accepts zero or one or two arguments which can be the LOCATION and 
# NAME for the host.
#
#  This script should run with the initial os shell which 
#  can be any of:  bash, ksh88, ksh93, pdksh
#

# TODO:
#   - tar -xf --checkpoint
#   - cvs checkout stdout/stderr to /dev/null
#   - Create a logfile.
#   - Too many packages are being brought over.
#   - Make the script verify it is the latest with a wget
#   - wget the undo if not already there.

opRunMachineArch=`uname -m`
typeset osType=`uname -s`
#typeset hostName=`uname -n`
typeset hostName=genesis1

typeset location="far"
typeset far_ShortCut=""
typeset atNeda_ShortCut="route -n add -net 198.62.92.0/24 gw 192.168.0.23"

dateTag=`date +%y%m%d%H%M%S`

#
# END OF CONFIGURATION PARAMETERS
# You should not need to edit anything below 
# this point.
# 

#
# To keep thing simple,
# by choice we are not using getopt and 
# option parsing is simple and limited.
#

function usage {
 cat  << _EOF_
$0 <location> <name>
  
   location:  is either "far" or "atNeda"
              DEFAULT location is far

   name:       must be a valid osmtId 
              DEFAULT name is genesis1

   if <location> is omitted, arg1 becomes <name>

EXAMPLES:
    $0 far genesis1  # DEFAULT
    $0 atNeda
    $0 far intraServer
_EOF_
}

if [ $# -eq 0 ] ; then
  #hostName=`uname -n`
  hostname=genesis1
  location="far"
elif [ $# -eq 1 ] ; then
  if [ "$1_" == "help_" ] ; then
    usage
    exit
  elif [ "$1_" == "far_" -o "$1_" == "atNeda_" ] ; then
    location=$1
  else
    hostName=$1
  fi
elif [ $# -eq 2 ] ; then
  if [ "$1_" == "far_" -o "$1_" == "atNeda_" ] ; then
    location=$1
  else
    print "Bad arg: $1"
    usage
    exit 100
  fi
  hostName=$2
else
  echo "Too Many Args -- $# -- $@"
  usage
  exit 2
fi




shopt -s expand_aliases
#alias continueAfterThis='echo "${G_myName}::$0:$LINENO"; _continueAfterThis; if [[ ${skipIt} == "true" ]] ; then return; fi;'
alias continueAfterThis='_continueAfterThis; if [[ ${skipIt} == "true" ]] ; then return; fi;'


function _continueAfterThis {
    #echo "About to: $*"
    echo -n "Hit enter to continue, \"skip\" to skip or \"EXIT\" to exit: "
    skipIt=false
    while read line ; do
	if [[ "${line}_" == "SKIP_"  || "${line}_" == "skip_" ]] ; then
	echo "Skiped"
	    skipIt=true
	    break
	fi

	if [[ "${line}_" == "EXIT_"  || "${line}_" == "exit_" ]] ; then
	    exit
	fi

	if [[ "${line}_" == "_" ]] ; then
	    #echo "Continuing ...."
	    break
	fi

	echo "HA! ${line} -- Say Again"
	echo -n "Hit enter to continue, \"skip\" to skip or \"EXIT\" to exit: "
    done
}

function ifNotCleanThenlpGenesisUndo {
  isClean="TRUE"

  if [ -d /here ] ; then 
    isClean="FALSE"
  elif [ -f /bin/osmtKsh ] ; then 
    isClean="FALSE"
  elif [ -f /etc/osmtInfo ] ; then 
    isClean="FALSE"
  else
    isClean="TRUE"
  fi
  
  if [ "${isClean}_" == "FALSE_" ] ; then
    echo "A Previous OSMT installation was observed"
    echo "We will next remove the old installation"
    echo "Use SKIP if you DONT wish to remove the old installation"

    continueAfterThis

    lpGenesisUndo
  fi
}
           

function lpGenesisUndo {

echo "removing any route shortcuts"

route -n delete -net 198.62.92.0/24 gw 192.168.0.23

netstat -r -n
continueAfterThis

echo "About to Undo Account"
continueAfterThis

/opt/public/osmt/bin/opAcctUsers.sh -h -v -n showRun -i acctDeleteAndRemoveHomeDir lsipusr


continueAfterThis

echo "RUNNING: /bin/rm -r -f /here"
/bin/rm -r -f /here

echo "RUNNING: /bin/rm -r -f  /opt"
/bin/rm -r -f  /opt

echo "RUNNING: /bin/rm /bin/osmtKsh"
/bin/rm /bin/osmtKsh

echo "RUNNING: /bin/rm /etc/osmtInfo"
/bin/rm /etc/osmtInfo 

}

function adjustSourcesList {

  case ${opRunDistFamily} in
    "UBUNTU"|"DEBIAN")
	  echo  "About To: Adjust (eliminate cdrom) sources.list"; continueAfterThis

	  if [ -f /etc/apt/sources.list.orig ] ; then 
	      cp /etc/apt/sources.list /etc/apt/sources.list.$$
	  else
	      cp -p /etc/apt/sources.list /etc/apt/sources.list.orig
	  fi

	  grep -v "cdrom" /etc/apt/sources.list > /tmp/sources.NoCdrom.$$

	  mv /tmp/sources.NoCdrom.$$ /etc/apt/sources.list

	  apt-get update
       ;;
    "MAEMO")

	  echo "/etc/apt/sources.list is assumed to be good"
       ;;
    "REDHAT"|"SOLARIS"|"UNKNOWN"|"UNSUPPORTED")
	  echo "Unsupported distribution: ${opRunDistFamily}"
	  return 1
       ;;
    *)
	  echo "Oops distribution: ${opRunDistFamily}"
	  return 1
       ;;
  esac

}

function installCVS {
  case ${opRunDistFamily} in
    "UBUNTU"|"DEBIAN")
	  echo  "About To: Install cvs"; continueAfterThis
	  apt-get install cvs
	  apt-get install sudo
       ;;
    "MAEMO")
	  echo  "About To: Install cvs"; continueAfterThis
	  apt-get -y install wget
	  wget http://www.bybinary.org/republish/maemo/4.x/armel/cvs
	  mv cvs /usr/bin/cvs
	  chmod 755 /usr/bin/cvs
       ;;
    "REDHAT"|"SOLARIS"|"UNKNOWN"|"UNSUPPORTED")
	  echo "Unsupported distribution: ${opRunDistFamily}"
	  return 1
       ;;
    *)
	  echo "Oops distribution: ${opRunDistFamily}"
	  return 1
       ;;
  esac
}

function bashAsOsmtKsh {
   echo  "About to Link /bin/bash to /bin/osmtKsh, Will run:"
   echo "ln -s /bin/bash  /bin/osmtKsh"

   continueAfterThis
   ln -s /bin/bash  /bin/osmtKsh
}

function setupRouteShortCuts {

  echo "Setting Up Route Short Cut (if applicable) For ${location}:"

  if [[ "${location}_" == "atNeda_" ]] ; then
    echo "Running: ${atNeda_ShortCut}"
    `${atNeda_ShortCut}`

    netstat -r -n
    continueAfterThis
  fi
}

function step2_getOsmt {
  echo  "About To: Get OSMT"; continueAfterThis
  mkdir -p /here/opt/public
  cd /here/opt/public

  echo "RUNNING: cvs -d :pserver:anoncvs@cvs.bysource.org:/rep1 checkout -d osmt public/dist-osmt"
  cvs -d :pserver:anoncvs@cvs.bysource.org:/rep1 checkout -d osmt public/dist-osmt 1>> /dev/null

  mkdir -p /opt/public
  ln -s /here/opt/public/osmt /opt/public/osmt
  export PATH=/opt/public/osmt/bin:${PATH}
}

function selectIntraGenesis1 {

  export PATH=/opt/public/osmt/bin:${PATH}
  typeset osmtSiteName="nedaPlus"

  echo "About To run:"
  echo "opSysIdentities.sh -v -n showRun -p opSiteName=${osmtSiteName} -i osmtIdentitySet ${hostName}"

  continueAfterThis

  opSysIdentities.sh -v -n showRun -p opSiteName=${osmtSiteName} -i osmtIdentitySet ${hostName}

  echo "About to run:"
  echo "cat /etc/osmtInfo"

  continueAfterThis
  
  cat /etc/osmtInfo

}

function step5_run_lpSysMgmtSteps {
    echo ""
    echo "Now that OSMT has been configured, the"
    echo "rest of the configuration, can be done"
    echo "lpSysMgmtSteps.sh"
    echo ""
    echo "You can run lpSysMgmtSteps.sh if it is does not complete properly"

  case ${opRunDistFamily} in
    "UBUNTU"|"DEBIAN")
    echo  "About To Run:" 
    echo  "export PATH=/opt/public/osmt/bin:${PATH}; lpSysMgmtSteps.sh -h -v -n showRun -p developer=noedit -i restartFromIdle" 

    continueAfterThis

    export PATH=/opt/public/osmt/bin:${PATH}
    #lpSysMgmtSteps.sh -h -v -n showRun  -p developer=noedit -i stepByStep
    lpSysMgmtSteps.sh -h -v -n showRun  -p developer=noedit -i restartFromIdle
       ;;
    "MAEMO")
    echo  "About To Run:" 
    echo  "export PATH=/opt/public/osmt/bin:${PATH}; lpMaemoMgmtSteps.sh -h -v -n showRun -p developer=noedit -i restartFromIdle" 

    continueAfterThis

    export PATH=/opt/public/osmt/bin:/usr/local/bin:${PATH}
    lpMaemoMgmtSteps.sh -h -v -n showRun  -p developer=noedit -i restartFromIdle
       ;;
    "REDHAT"|"SOLARIS"|"UNKNOWN"|"UNSUPPORTED")
	  echo "Unsupported distribution: ${opRunDistFamily}"
	  return 1
       ;;
    *)
	  echo "Oops distribution: ${opRunDistFamily}"
	  return 1
       ;;
  esac
}

function welcomeMessage {
    echo ""
    echo "Welcome to the Libre Services Integration Platform (LSIP)"
    echo "installation script"
    echo ""
    echo "First we will install the Libre Platform and then"
    echo "we will configure this host with the chosen configuration"
    echo ""
    echo "You are about to install the Libre Platform"
    echo "When in doubt, hit enter and select the default"

    echo opRunDistFamily=${opRunDistFamily}
    echo opRunDistGeneration=${opRunDistGeneration}
    echo opRunDistGenNu=${opRunDistGenNu}


    continueAfterThis
}


function installKsh93 {

  case ${opRunDistFamily} in
    "UBUNTU"|"DEBIAN")
	  # echo  "About To: Get ksh93"; continueAfterThis
  
	  case ${opRunMachineArch} in
	  "i686"|"i586"|"i386")
	  #    mkdir -p /here/opt/public/mma/multiArch/Linux/i686/bin
	  #    cd /here/opt/public/mma/multiArch/Linux/i686/bin
	  #    wget http://www.bysource.org/mma/multiArch/Linux/i686/bin/ksh93
	  #    chmod 775 ksh93
	  #    mkdir -p /opt/public
	  #    ln -s /here/opt/public/mma /opt/public
	  #    ln -s /opt/public/mma/multiArch/Linux/i686/bin/ksh93 /bin/osmtKsh

	     echo "Skipping Ksh93 for ${opRunDistFamily} -- ${opRunMachineArch}"
	     mkdir -p /opt/public
	     ln -s /bin/bash /bin/osmtKsh
	     ;;
          *)

	     echo "Skipping Ksh93 for ${opRunDistFamily} -- ${opRunMachineArch}"
	     mkdir -p /opt/public
	     ln -s /bin/bash /bin/osmtKsh
	     ;;
          esac
	  ;;
    "MAEMO")
	  echo  "About To: Get ksh93"; continueAfterThis
	  echo "Skipping Ksh93 for ${opRunDistFamily} -- ${opRunMachineArch}"
	  mkdir -p /opt/public
          ln -s /bin/bash /bin/osmtKsh
       ;;
    "REDHAT"|"SOLARIS"|"UNKNOWN"|"UNSUPPORTED")
	  echo "Unsupported distribution: ${opRunDistFamily}"
	  return 1
       ;;
    *)
	  echo "Oops distribution: ${opRunDistFamily}"
	  return 1
       ;;
  esac
}

function endOfLpInstallMessage {
    echo ""
    echo "Libre Platform has been successfully installed"
    echo ""
    echo "Next we will configure your host"

    continueAfterThis
}


vis_opRunDistFamilySet () {

  opRunDistFamily="UNKNOWN"
  
  if grep buntu /etc/issue ; then
    opRunDistFamily="UBUNTU"
  elif grep "Debian GNU/Linux" /etc/issue ; then
    opRunDistFamily="DEBIAN"
 elif grep "maemo" /etc/issue ; then
    opRunDistFamily="MAEMO"
 elif grep "Red Hat" /etc/issue ; then
    opRunDistFamily="REDHAT"
 elif grep "Solaris" /etc/issue ; then
    opRunDistFamily="SOLARIS"
  else
    opRunDistFamily="UNSUPPORTED"
  fi

  opRunDistGeneration="UNKNOWN"
  case ${opRunDistFamily} in
    "UBUNTU")
	      if grep "14.04" /etc/issue ; then
		opRunDistGeneration="1404"
		opRunDistGenNu="14.04"
	      elif grep "Xenial" /etc/issue ; then
		opRunDistGeneration="1604"
		opRunDistGenNu="16.04"
	      elif grep "16.04" /etc/issue ; then
		opRunDistGeneration="1604"
		opRunDistGenNu="16.04"
	      elif grep "Beaver" /etc/issue ; then  # LTS
		opRunDistGeneration="1804"
		opRunDistGenNu="18.04"
	      elif grep "18.04" /etc/issue ; then  # LTS
		opRunDistGeneration="1804"
		opRunDistGenNu="18.04"
	      elif grep "Focal" /etc/issue ; then  # LTS
		opRunDistGeneration="2004"
		opRunDistGenNu="20.04"
	      elif grep "20.04" /etc/issue ; then  # LTS
		opRunDistGeneration="2004"
		opRunDistGenNu="20.04"
	      else
		opRunDistGeneration="UNSUPPORTED"
		opRunDistGenNu="UNSUPORTED"
	      fi
       ;;
    "DEBIAN")
	      if grep "3.1" /etc/issue ; then
		opRunDistGeneration="SARGE"
		opRunDistGenNu="3.1"
	      elif grep "4.0" /etc/issue ; then
		opRunDistGeneration="ETCH"
		opRunDistGenNu="4.0"
	      elif grep "5.0" /etc/issue ; then
		opRunDistGeneration="LENNY"
		opRunDistGenNu="5.0"
	      elif grep "squeeze" /etc/issue ; then
		opRunDistGeneration="SQUEEZE"
		opRunDistGenNu="6.0"
	      elif grep "6.0" /etc/issue ; then
		opRunDistGeneration="SQUEEZE"
		opRunDistGenNu="6.0"
	      elif grep "7.0" /etc/issue ; then
		opRunDistGeneration="7"
		opRunDistGenNu="7.0"
	      elif grep "sid" /etc/issue ; then
		opRunDistGeneration="SID"
		opRunDistGenNu="UNSTABLE"
	      else
		opRunDistGeneration="UNSUPPORTED"
		opRunDistGenNu="UNSUPORTED"
	      fi
       ;;
    "MAEMO")
	      if grep "OS2008" /etc/issue ; then
		opRunDistGeneration="OS2008"
		opRunDistGenNu="2008"
	      elif grep "OS2009" /etc/issue ; then
		opRunDistGeneration="OS2009"
		opRunDistGenNu="2009"
	      fi
       ;;
    "REDHAT")
	     opRunDistGeneration="UNSUPPORTED"
       ;;
    "SOLARIS")
	     opRunDistGeneration="UNSUPPORTED"
       ;;
    "UNKNOWN")
	       opRunDistGeneration="UNSUPPORTED"
       ;;
    "UNSUPPORTED")
		   opRunDistGeneration="UNSUPPORTED"
       ;;
    *)
       opRunDistGeneration="UNSUPPORTED"
	EH_oops ;
       return
       ;;
  esac

    echo opRunDistFamily=${opRunDistFamily}
    echo opRunDistGeneration=${opRunDistGeneration}
    echo opRunDistGenNu=${opRunDistGenNu}

}

vis_opRunDistFamilyShow () {

  #opRunDistFamily=""

  if [ "${opRunDistFamily}_" == "_" ]  ; then
    echo "Need to run -- opSysIdentities.sh -i osmtInfoExpand"
    echo ${G_myName} -v -n showRun  -i opRunDistFamilySet
  else

    echo opRunDistFamily=${opRunDistFamily}
    echo opRunDistGeneration=${opRunDistGeneration}
  fi
}


vis_opRunDistFamilySet

#vis_opRunDistFamilyShow

welcomeMessage

ifNotCleanThenlpGenesisUndo

setupRouteShortCuts

#step1_getNecessarySoftware
adjustSourcesList
installCVS

step2_getOsmt

installKsh93
#bashAsOsmtKsh

selectIntraGenesis1
#step4_determineNetwork

endOfLpInstallMessage

step5_run_lpSysMgmtSteps

