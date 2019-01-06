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
$( examplesSeperatorSection "BISOS BaseDirs Setup" )
${G_myName} ${extraInfo} -i bisosBaseDirsSetup
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
	ANT_cooked "Python already install -- Skipped"
    else
	lpDo sudo apt-get -y install python-minimal
    fi

    if which pip ; then
	ANT_cooked "Pip already install -- Skipped"
    else
	lpDo sudo apt-get -y install python-pip	
    fi

    if which python3 ; then 
	ANT_cooked "Python3 already install -- Skipped"
    else
	lpDo sudo apt-get install -y python3.7 
    fi

    if which pip3 ; then
	ANT_cooked "Pip3 already install -- Skipped"
    else
	lpDo sudo apt-get -y install python3-pip	
    fi
    
    lpDo sudo -H pip install --no-cache-dir --upgrade pip
    lpDo sudo -H pip install --no-cache-dir --upgrade virtualenv
    lpDo sudo -H pip install --no-cache-dir --upgrade bisos.bx-bases
    lpDo sudo -H pip install --no-cache-dir --upgrade bisos.platform    

    lpDo sudo -H pip list

    lpReturn
}


function vis_bisosBaseDirsSetup {
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

    #local currentUser=$(id -un)
    #local currentUserGroup=$(id -g -n ${currentUser})

    local currentUser="bisos"
    local currentUserGroup="bisos"
    
    local bisosRootDir="/bisos"
    local bxoRootDir="/bxo"
    local deRunRootDir="/de/run"        

    lpDo sudo bx-platformInfoManage.py --bisosUserName="${currentUser}"  -i pkgInfoParsSet
    lpDo sudo bx-platformInfoManage.py --bisosGroupName="${currentUserGroup}"  -i pkgInfoParsSet     

    lpDo sudo bx-platformInfoManage.py --rootDir_bisos="${bisosRootDir}"  -i pkgInfoParsSet
    lpDo sudo bx-platformInfoManage.py --rootDir_bxo="${bxoRootDir}"  -i pkgInfoParsSet
    lpDo sudo bx-platformInfoManage.py --rootDir_deRun="${deRunRootDir}"  -i pkgInfoParsSet    

    echoAnn "========= bx-platformInfoManage.py -i pkgInfoParsGet ========="
    lpDo bx-platformInfoManage.py -i pkgInfoParsGet

    lpDo sudo mkdir -p "${bisosRootDir}"
    lpDo sudo chown -R ${currentUser}:${currentUserGroup} "${bisosRootDir}"

    lpDo sudo mkdir -p "${bxoRootDir}"
    lpDo sudo chown -R ${currentUser}:${currentUserGroup} "${bxoRootDir}"

    lpDo sudo mkdir -p "${deRunRootDir}"
    lpDo sudo chown -R ${currentUser}:${currentUserGroup} "${deRunRootDir}"
    
    #
    # With the above rootDirs in place, bx-bases need not do any sudo-s
    #
    lpDo sudo /bin/rm /tmp/NOTYET.log  # NOTYET
    lpDo sudo -H -u ${currentUser} bx-bases -v 20 --baseDir="${bisosRootDir}" -i pbdUpdate all
}


