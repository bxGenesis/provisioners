#!/bin/bash

IcmBriefDescription="NOTYET: Short Description Of The Module"

####+BEGIN: bx:dblock:global:file-insert :mode "none" :file "../lib/bash/mainRepoRootDetermine.bash"
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

####+BEGIN: bx:dblock:global:file-insert :mode "none" :file "../lib/bash/seedIcmLoad.bash"
#
# DO NOT EDIT THIS SECTION (dblock)
# ../lib/bash/seedIcmLoad.bash common dblock inserted code
#
if [ "${loadFiles}" == "" ] ; then
    "${mainRepoRoot}/bin/seedIcmSelfReliant.bash" -l $0 "$@" 
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

. ${opBinBase}/sharedParameters_lib.sh
. ${opBinBase}/bisosProvisioners_lib.sh

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
${G_myName} ${extraInfo} -p runAs=bisos -i pyPkgInstall py3-bisos-3 unisos.marme
${G_myName} ${extraInfo} -i pyPkgInstall py3-bisos-3 unisos.marme
$( examplesSeperatorSection "BISOS BaseDirs Setup" )
${G_myName} ${extraInfo} -i marme_install
${G_myName} ${extraInfo} -p runAs=bisos -i marme_install
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

    local activateFile=""

    local thisUmask="0002"

    if [ "${runAs}" == "" ] ; then
       runAs=$(id -un)
    fi

    
    if [ "$( type -t deactivate )" == "function" ] ; then
        echoAnn "Deactivating"
        deactivate
    fi

    if [ -d "${virtEnv}" ] ; then
        activateFile=${virtEnv}/bin/activate
    else
        local bisosRootDir=$( bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
        local bisosVirtEnvBase="${bisosRootDir}/venv/${virtEnv}"
        if [ -d "${bisosVirtEnvBase}" ] ; then
            activateFile=${bisosVirtEnvBase}/bin/activate
        else
            EH_problem "Missing  ${bisosVirtEnvBase}"
            lpReturn
        fi
    fi

    if [ ! -f "${activateFile}" ] ; then
        EH_problem "Missing  ${activateFile}"
        lpReturn
    fi

    ANT_raw "Running as ${runAs} with umask=${thisUmask}"

    sudo -H -u ${runAs} bash << _EOF_
    umask ${thisUmask}

    source ${activateFile}

    set -x

    pip -V    

    pip install --no-cache-dir --upgrade "${pkgName}"
    
    pip list
_EOF_

    lpReturn
}


function vis_marme_install {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local pkgName=unisos.marme
    local bisosVenvName=py3-bisos-3

    lpDo vis_pyPkgInstall "${bisosVenvName}" ${pkgName}
}
    
