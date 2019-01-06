#!/bin/bash

IcmBriefDescription="NOTYET: Short Description Of The Module"

####+BEGIN: bx:dblock:global:file-insert :file "../lib/bash/mainRepoRootDetermine.bash"
#
# DO NOT EDIT THIS SECTION (dblock)
# ../lib/bash/mainRepoRootDetermine.bash common dblock inserted code
#
mainRepoRoot=$( cd $(dirname $0); git rev-parse --show-toplevel 2> /dev/null )
if [ -z "${mainRepoRoot}" ] ; then
    echo "E: Missing Git Base:: $0 is not in an expected git"
    exit 1
fi

####+END:

####+BEGIN: bx:dblock:global:file-insert :file "../lib/bash/seedIcmLoad.bash"
#
# DO NOT EDIT THIS SECTION (dblock)
# ../lib/bash/seedIcmLoad.bash common dblock inserted code
#
if [ "${loadFiles}" == "" ] ; then
    "${mainRepoRoot}/bin/seedIcmStandalone.bash" -l $0 "$@" 
    exit $?
fi

####+END:


function vis_describe {  cat  << _EOF_
Module description comes here.
_EOF_
		      }

# Import Libraries

#
. ${opLibBase}/pidLib.sh
# # /opt/public/osmt/lib/portLib.sh
. ${opLibBase}/portLib.sh


function G_postParamHook {
     return 0
}

function vis_examples {
    typeset extraInfo="-h -v -n showRun"
    #typeset extraInfo=""
    typeset runInfo="-p ri=lsipusr:passive"

    typeset examplesInfo="${extraInfo} ${runInfo}"

    visLibExamplesOutput ${G_myName} 
  cat  << _EOF_
$( examplesSeperatorTopLabel "${G_myName}" )
$( examplesSeperatorChapter "BISOS Bases Initialization" )
$( examplesSeperatorSection "Python System Environment Setup (For Virtenv)" )
${G_myName} ${extraInfo} -i pythonSysEnvPrepForVirtenvs
$( examplesSeperatorSection "bxContainer" )
${G_myName} ${extraInfo} -i bxContainer
_EOF_
}

noArgsHook() {
  vis_examples
}


function echoErr { echo "E: $@" 1>&2; }
function echoAnn { echo "A: $@" 1>&2; }
function echoOut { echo "$@"; }


function vis_pythonSysEnvPrepForVirtenvs {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if [ "$( type -t deactivate )" == "function" ] ; then
	deactivate
    fi

    if which python ; then 
	lpDo sudo apt-get -y install python-minimal
    else
	ANT_here "Python already install -- Skipped"
    fi

    if which pip ; then
	lpDo sudo apt-get -y install python-pip	
    else
	ANT_here "Pip already install -- Skipped"
    fi
    
    lpDo sudo -H pip install --no-cache-dir --upgrade pip
    lpDo sudo -H pip install --no-cache-dir --upgrade virtualenv
    lpDo sudo -H pip install --no-cache-dir --upgrade bisos.bx-bases

    lpDo sudo -H pip list

    lpReturn
}


function vis_bisosBaseDirSetup {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]


#
# Running user should have sudo privileges
# 
#

    local currentUser=$(id -un)
    local currentUserGroup=$(id -g -n ${currentUser})

    local bisosRootDir="/bisos"
    local bxoRootDir="/bxo"
    local deRunRootDir="/de/run"        


    bx-platformInfoManage.py --bisosUserName="${currentUser}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --bisosGroupName="${currentUserGroup}"  -i pkgInfoParsSet     

    bx-platformInfoManage.py --rootDir_bisos="${bisosRootDir}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --rootDir_bxo="${bxoRootDir}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --rootDir_deRun="${deRunRootDir}"  -i pkgInfoParsSet    

    echoAnn "========= bx-platformInfoManage.py -i pkgInfoParsGet ========="
    bx-platformInfoManage.py -i pkgInfoParsGet

    sudo mkdir -p "${bisosRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${bisosRootDir}"

    sudo mkdir -p "${bxoRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${bxoRootDir}"

    sudo mkdir -p "${deRunRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${deRunRootDir}"
    
    #
    # With the above rootDirs in place, bx-bases need not do any sudo-s
    #
    bx-bases -v 20 --baseDir="${bisosRootDir}" -i pbdUpdate all
}


