#!/bin/bash

#
# This file is sourced by bisosProvisioner.sh script and its feature
# providers.
#


function vis_rootDirProvisionersGet {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
This function also exists in /usr/local/bin/bisosProvision.sh where 
it is specified or is read from bx-platformInfoManage.py.
Here we descend from the git's SelfReliantBase.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local thisSelfReliantBase=$( vis_basedOnGitDetermineThisSelfReliantBase )

    if [ ! -z "${rootDir_provisioners}" ] ; then
        if [ "${thisSelfReliantBase}" != "${rootDir_provisioners}" ] ; then
            EH_problem "Inconsistent rootDir_provisioners=${rootDir_provisioners} ${thisSelfReliantBase}"
        fi
    fi
    echo "${thisSelfReliantBase}"
}


function vis_basedOnGitDetermineThisSelfReliantBase {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    #
    # selfreliant icm seed  sets up thisGitRoot=$( cd $(dirname $0); git rev-parse --show-toplevel 2> /dev/null )
    #

    inBaseDirDo ${thisGitRoot}/../.. pwd
}



_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_unsupportedPlatform_p    [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_unsupportedPlatform_p {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Ubuntu 2004
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    #if vis_reRunAsRoot G_thisFunc $@ ; then lpReturn globalReRunRetVal; fi;    

    lpReturn
}       

