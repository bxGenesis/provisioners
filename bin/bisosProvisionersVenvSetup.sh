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
Assumes that python and pip and virtualenv are in place

- creates /opt/bisosProvisioners/venv/py2,3
- activates venv
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
${G_myName} ${extraInfo} -i virtenvsPrep
${G_myName} ${extraInfo} -i venvPipInstalls
_EOF_
}

noArgsHook() {
  vis_examples
}

proisionersBaseDir="/opt/bisosProvisioner}"

venvBasePy2="${proisionersBaseDir}/venv/py2"
venvBasePy3="${proisionersBaseDir}/venv/py3"    



function vis_virtenvsPrep {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]


    lpDo virtualenv --python=python3 ${venvBasePy3}

    lpDo virtualenv --python=python2 ${venvBasePy2}    
    
    lpReturn
}


_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  IIFs          :: Interactively Invokable Functions (IIF)s |  [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_venvPipInstalls {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Make sure python2 and python3 and their pips are in place
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]


    local py2ActivateFile="${venvBasePy2}/bin/activate"

    source ${py2ActivateFile}
    
    lpDo pip install bisos.bx-bases

    lpDo pip install bisos.platform

    which -a bx-platformInfoManage.py

    lpDo pip list 
    
    # touch /tmp/NOTYET.log

    # sudo bx-platformInfoManage.py -v 20  -i pkgInfoParsDefaultsSet bxoPolicy /

    # sudo bx-platformInfoManage.py  -i pkgInfoParsGet

    # sudo bx-bases -v 20  -i pbdRootsForPlatform all         # Create Root Bases

    # bx-bases -v 20 --baseDir="/bisos" --pbdName="bisosRoot"  -i pbdUpdate all

    # /bin/bash: virtualenv: command not found

    # bx-bases -v 20 --baseDir="/de" --pbdName="deRunRoot"  -i pbdUpdate all

    # bx-bases -v 20 --baseDir="/bxo" --pbdName="bxoRoot"  -i pbdUpdate all

    # sudo apt install git

    # bx-gitReposBases -v 20 --baseDir="/bisos/vc/git/bxRepos/anon" --pbdName="bxReposRoot" --vcMode="anon"  -i pbdUpdate all


    # cd /bisos/blee

    # ln -s /bisos/vc/git/bxRepos/anon/blee/env

    # cd /bisos/vc/git/bxRepos/anon/blee
    # git clone git@github.com:bx-blee/org-img-link.git
    
    lpReturn
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


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_python3    [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstall_python3 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo sudo apt-get install -y python3

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

    opDo sudo apt-get install -y python2

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

    opDo sudo apt-get install -y pip3

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

    # cd /tmp; curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
    # sudo python2 /tmp/get-pip.py
    lpDo sudo -H pip2 install --no-cache-dir --upgrade pip2
    
    lpReturn
}	


_CommentBegin_
*  [[elisp:(org-cycle)][| ]] [[elisp:(org-show-subtree)][|=]] [[elisp:(show-children 10)][|V]] [[elisp:(blee:ppmm:org-mode-toggle)][|N]] [[elisp:(bx:orgm:indirectBufOther)][|>]] [[elisp:(bx:orgm:indirectBufMain)][|I]] [[elisp:(beginning-of-buffer)][|^]] [[elisp:(org-top-overview)][|O]] [[elisp:(progn (org-shifttab) (org-content))][|C]] [[elisp:(delete-other-windows)][|1]] || IIC       ::  vis_sysInstall_pip3   [[elisp:(org-cycle)][| ]]
_CommentEnd_


function vis_sysInstal_virtualenv3 {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo sudo -H pip3 install --no-cache-dir --upgrade virtualenv    

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

