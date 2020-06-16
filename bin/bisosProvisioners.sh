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
    "${mainRepoRoot}/bin/seedIcmSelfcontained.bash" -l $0 "$@" 
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
. ${opLibBase}/portLib.sh

. ${opBinBase}/sharedParameters_lib.sh

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
$( examplesSeperatorChapter "Git Enable, Activate, Prep" )
$( examplesSeperatorSection "Git Auth (Development) Setups" )
${G_myName} ${extraInfo} -i gitPrepAuth
${G_myName} ${extraInfo} -i gitActivateAuth
${G_myName} ${extraInfo} -i gitEnableAuth
$( examplesSeperatorSection "Git Anon (Released) Setups" )
${G_myName} ${extraInfo} -i gitPrepAnon
${G_myName} ${extraInfo} -i gitActivateAnon
$( examplesSeperatorChapter "BISOS Bootstraping Profiles" )
$( examplesSeperatorSection "bxDistro" )
${G_myName} ${extraInfo} -i bxDistro
$( examplesSeperatorSection "bxContainer" )
${G_myName} ${extraInfo} -i bxContainer
$( examplesSeperatorSection "bxVmHostPrepVirts" )
${G_myName} ${extraInfo} -i bxVmHostPrepVirts kvm
${G_myName} ${extraInfo} -i bxVmHostPrepVirts kvm virtualbox
_EOF_
}

noArgsHook() {
  vis_examples
}

function vis_gitPrepAuth {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo bisosAccounts.sh -h -v -n showRun -i fullUpdate passwd_tmpSame

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpReturn
}

function vis_gitPrepAnon {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo bisosAccounts.sh -h -v -n showRun -i fullUpdate passwd_tmpSame

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpReturn
}



function vis_gitEnableAuth {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )

    local gitReposAuthBase="${selfcontainedBase}/gitReposAuth"
    local gitReposBase="${selfcontainedBase}/gitRepos"    
    

    #echo ${selfcontainedBase}

    

    lpReturn
}


function vis_gitActivateAnon {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo bisosAccounts.sh -h -v -n showRun -i fullUpdate passwd_tmpSame

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpReturn
}


function vis_bxContainer {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo bisosAccounts.sh -h -v -n showRun -i fullUpdate passwd_tmpSame

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpDo bisosBaseDirSetup.sh -h -v -n showRun -i bisosBaseDirsSetup

    lpReturn
}


function vis_bxDistro {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    ANT_raw "Nothing Has Been Added To The Distro"

    lpReturn
}


function vis_bxVmHostPrepVirts {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -gt 0 ]]

    local inputsList="$@"
    local each=""
    local thisFunc=${G_thisFunc}

    function processEach {
	EH_assert [[ $# -eq 1 ]]
	local virtProvider=$1
	case ${virtProvider} in
	    kvm)
		EH_problem "KVM notyet"
		;;
	    virtualbox)
		EH_problem "VirtualBox notyet"		
		;;
	    vmware)
		EH_problem "Vmware notyet"				
		;;
	    *)
		EH_problem "Unknown ${virtProvider} notyet"
		;;
	esac
    }
    
    for each in ${inputsList} ; do
	lpDo processEach ${each}
    done
    
    lpReturn
}
