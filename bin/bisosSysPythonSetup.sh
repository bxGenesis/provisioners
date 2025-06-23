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


_CommentBegin_
####+BEGIN: bx:dblock:global:file-insert-cond :cond "./blee.el" :file "/libre/ByStar/InitialTemplates/software/plusOrg/dblock/inserts/topControls.org"
*  /Controls/ ::  [[elisp:(org-cycle)][| ]]  [[elisp:(show-all)][Show-All]]  [[elisp:(org-shifttab)][Overview]]  [[elisp:(progn (org-shifttab) (org-content))][Content]] | [[file:Panel.org][Panel]] | [[elisp:(blee:ppmm:org-mode-toggle)][Nat]] | [[elisp:(bx:org:run-me)][Run]] | [[elisp:(bx:org:run-me-eml)][RunEml]] | [[elisp:(delete-other-windows)][(1)]] | [[elisp:(progn (save-buffer) (kill-buffer))][S&Q]]  [[elisp:(save-buffer)][Save]]  [[elisp:(kill-buffer)][Quit]] [[elisp:(org-cycle)][| ]]
** /Version Control/ ::  [[elisp:(call-interactively (quote cvs-update))][cvs-update]]  [[elisp:(vc-update)][vc-update]] | [[elisp:(bx:org:agenda:this-file-otherWin)][Agenda-List]]  [[elisp:(bx:org:todo:this-file-otherWin)][ToDo-List]]
####+END:
_CommentEnd_

_CommentBegin_
*      ================
*  [[elisp:(beginning-of-buffer)][Top]] ################ [[elisp:(delete-other-windows)][(1)]] CONTENTS-LIST ################
*  [[elisp:(org-cycle)][| ]]  Notes         :: *[Current-Info:]*  Status, Notes (Tasks/Todo Lists, etc.) [[elisp:(org-cycle)][| ]]
_CommentEnd_

function vis_moduleDescription {  cat  << _EOF_
*  [[elisp:(org-cycle)][| ]]  Xrefs         :: *[Related/Xrefs:]*  <<Xref-Here->>  -- External Documents  [[elisp:(org-cycle)][| ]]
**  [[elisp:(org-cycle)][| ]]  Panel        :: [[file:/libre/ByStar/InitialTemplates/activeDocs/bxServices/versionControl/fullUsagePanel-en.org::Xref-VersionControl][Panel Roadmap Documentation]] [[elisp:(org-cycle)][| ]]
*  [[elisp:(org-cycle)][| ]]  Info          :: *[Module Description:]* [[elisp:(org-cycle)][| ]]

Assumes that bisos account exists.

- SysInstalls python 2,3 and pip 2,3
- pip installs virtenv2/3
- creates /opt/bisosProvisioners/venv/py2,3
- pip installs bisos.bases

_EOF_
}

_CommentBegin_
*  [[elisp:(beginning-of-buffer)][Top]] ################ [[elisp:(delete-other-windows)][(1)]]  *Seed Extensions*
_CommentEnd_

_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  Imports       :: Prefaces (Imports/Libraries) [[elisp:(org-cycle)][| ]]
_CommentEnd_


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
${G_myName} ${extraInfo} -i sysInstall_python3
${G_myName} ${extraInfo} -i sysInstall_python2
${G_myName} ${extraInfo} -i sysInstall_pip3
${G_myName} ${extraInfo} -i sysInstall_pip2
${G_myName} ${extraInfo} -i sysPipInstall_virtualenv3
${G_myName} ${extraInfo} -i sysPipInstall_bisosPlatform
${G_myName} ${extraInfo} -i provisionPipxBin_set
_EOF_
}

noArgsHook() {
  vis_examples
}



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

    # if vis_unsupportedPlatform_p
    #    EH_problem "Unsupported Platform"
    #    lpReturn 101
    # fi

    opDo vis_sysInstall_python3

    # opDo vis_sysInstall_python2

    opDo vis_sysInstall_pip3

    # opDo vis_sysInstall_pip2

    opDo vis_sysPipInstall_virtualenv3

    vis_sysPipInstall_bisosPlatform    # This actually uses pip3 -- should be renamed. NOTYET

    # lpDo sudo -H pip list

    lpReturn
}


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_python3    [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstall_python3 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if which python3 ; then 
        ANT_cooked "Python3 already install -- Skipped"
    else
        lpDo sudo apt-get install -y python3 
    fi

    lpReturn
}       


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_python2    [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstall_python2 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if sysOS_isDeb13 ; then
        EH_problem "Obsolete invokation of  vis_sysInstall_python2 -- To Be Deleted"
        lpReturn
    fi

    if sysOS_isDeb12 ; then
        EH_problem "Obsolete invokation of  vis_sysInstall_python2 -- To Be Deleted"
        lpReturn
    fi


    if which python2 ; then 
        ANT_cooked "Python2 already install -- Skipped"
    else
        lpDo sudo apt-get install -y python2 
    fi

    lpReturn
}       


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_pip3   [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstall_pip3 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if which pip3 ; then
        ANT_cooked "Pip3 already install -- Skipped"
    else
        lpDo sudo apt-get -y install python3-pip        
    fi

    if sysOS_isDeb11 ; then
        lpDo sudo -H pip3 install --no-cache-dir --upgrade pip
    fi

    lpReturn
}       



_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_pip2   [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstall_pip2 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if sysOS_isDeb13 ; then
        EH_problem "Obsolete invokation of  vis_sysInstall_pip2 -- To Be Deleted"
        lpReturn
    fi

    if sysOS_isDeb12 ; then
        EH_problem "Obsolete invokation of  vis_sysInstall_pip2 -- To Be Deleted"
        lpReturn
    fi

    lpDo sudo apt-get install -y curl  # needed below
    
    if which pip2 ; then
        ANT_cooked "Pip2 already install -- Skipped"
    else
        cd /tmp; curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2 /tmp/get-pip.py
    fi
    
    lpDo sudo -H pip2 install --no-cache-dir --upgrade pip
    
    lpReturn
}       


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysPipInstall_virtualenv3   [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysPipInstall_virtualenv3 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
We can only have one version of virtualenv. So, there is no vis_sysPipInstall_virtualenv2.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if sysOS_isDeb12 ; then
        lpDo sudo apt-get -y install python3-virtualenv
    elif sysOS_isDeb11 ; then
        lpDo sudo -H pip3 install --no-cache-dir --upgrade virtualenv
    else
        EH_problem "Unsupport sysOS  sysOS=${sysOS}, sysDist=${sysDist}, sysID=${sysID}"
    fi

    lpReturn
}       


function vis_provisionPipxBin_set {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo eval echo $HOME/.local/bin \> /tmp/bisosProvisionPipxBin
}


function vis_sysPipInstall_bisosPlatform {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
To provide parameters for destination provisioning
*** NOTYET, should be renamed to get rid of 2.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local pipxBase="/tmp/bisosPipx"

    if sysOS_isDeb13 ; then
        lpDo mkdir ${pipxBase}
        lpDo chmod 777 ${pipxBase}
        lpDo env PIPX_HOME=${pipxBase} PIPX_BIN_DIR=${pipxBase}/bin pipx install bisos.platform
        lpDo env PIPX_HOME=${pipxBase} PIPX_BIN_DIR=${pipxBase}/bin pipx install bisos.bx-bases
        # lpDo vis_provisionPipxBin_set
    elif sysOS_isDeb12 ; then
        lpDo mkdir ${pipxBase}
        lpDo chmod 777 ${pipxBase}
        lpDo env PIPX_HOME=${pipxBase} PIPX_BIN_DIR=${pipxBase}/bin pipx install bisos.platform
        lpDo env PIPX_HOME=${pipxBase} PIPX_BIN_DIR=${pipxBase}/bin pipx install bisos.bx-bases
        # lpDo vis_provisionPipxBin_set
    elif sysOS_isDeb11 ; then
        lpDo sudo -H pip3 install --no-cache-dir --upgrade bisos.platform
    else
        EH_problem "Unsupport sysOS  sysOS=${sysOS}, sysDist=${sysDist}, sysID=${sysID}"
    fi


    lpReturn
}       


_CommentBegin_
*  [[elisp:(beginning-of-buffer)][Top]] ################ [[elisp:(delete-other-windows)][(1)]]  *End Of Editable Text*
_CommentEnd_

####+BEGIN: bx:dblock:bash:end-of-file :type "basic"
_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  Common        ::  /[dblock] -- End-Of-File Controls/ [[elisp:(org-cycle)][| ]]
_CommentEnd_
#+STARTUP: showall
#local variables:
#major-mode: sh-mode
#fill-column: 90
# end:
####+END:

