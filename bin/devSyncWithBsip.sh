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
${G_myName} ${extraInfo} -i diffs
${G_myName} ${extraInfo} -i update
_EOF_
}

noArgsHook() {
  vis_examples
}


function vis_diffs {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo diff /bisos/core/bsip/bin/unisosAccounts_lib.sh ./unisosAccounts_lib.sh

    opDo diff /bisos/core/bsip/bin/bisosGroupAccount_lib.sh ./bisosGroupAccount_lib.sh

    opDo diff /bisos/core/bsip/bin/platformBases_lib.sh  ./platformBases_lib.sh

    lpReturn
}


function vis_update {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if cmp /bisos/core/bsip/bin/unisosAccounts_lib.sh ./unisosAccounts_lib.sh; then
        ANT_raw "Same, update skipped -- /bisos/core/bsip/bin/unisosAccounts_lib.sh ./unisosAccounts_lib.sh"    
    else
        lpDo cp /bisos/core/bsip/bin/unisosAccounts_lib.sh ./unisosAccounts_lib.sh
    fi

    if cmp /bisos/core/bsip/bin/bisosGroupAccount_lib.sh ./bisosGroupAccount_lib.sh; then
        ANT_raw "Same, update skipped -- /bisos/core/bsip/bin/bisosGroupAccount_lib.sh ./bisosGroupAccount_lib.sh"
    else
        lpDo cp /bisos/core/bsip/bin/bisosGroupAccount_lib.sh ./bisosGroupAccount_lib.sh        
    fi

    if cmp /bisos/core/bsip/bin/platformBases_lib.sh ./platformBases_lib.sh; then
        ANT_raw "Same, update skipped -- /bisos/core/bsip/bin/platformBases_lib.sh ./platformBases_lib.sh"
    else
        lpDo cp /bisos/core/bsip/bin/platformBases_lib.sh ./platformBases_lib.sh        
    fi

    lpReturn
}

