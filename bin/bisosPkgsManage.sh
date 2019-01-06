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
$( examplesSeperatorChapter "BISOS Packages Management" )
$( examplesSeperatorSection "Python Package Installer" )
${G_myName} ${extraInfo} -i pyPkgInstall py2-bisos-3 unisos.marme 
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

function vis_pyPkgInstall {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 2 ]]

    local virtEnv="$1"
    local pkgName="$2"

    
    if [ "$( type -t deactivate )" == "function" ] ; then
	echoAnn "Deactivating"
	deactivate
    fi

    #bisosRootDir=$( bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
    #bisosVirtEnvBase="${bisosRootDir}/venv/${bisosVenvName}"
    

    source ${virtEnv}/bin/activate

    lpDo pip install --no-cache-dir --upgrade "${pkgName}"
    
    lpReturn
}


function vis_marme_install {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    pkgName=unisos.marme
    bisosVenvName=py2-bisos-3

    #########  End-Of-Params-Specification ###########

    if [ "$( type -t deactivate )" == "function" ] ; then
	deactivate
    fi

    #PATH="$PATH:."

    if [ ! -d "${bisosVirtEnvBase}" ] ; then
	bisosBasesDirSetup.sh
    fi

    bisosRootDir=$( bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
    bisosVirtEnvBase="${bisosRootDir}/venv/${bisosVenvName}"

    lpDo vis_pyPkgInstall "${bisosVirtEnvBase}" ${pkgName}
}
    
