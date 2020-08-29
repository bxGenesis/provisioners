#!/bin/bash # -*- mode: sh-mode; -*-

IimBriefDescription="NOTYET: Short Description Of The Module"

ORIGIN="
* Revision And Libre-Halaal CopyLeft -- Part Of ByStar -- Best Used With Blee
"

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+brief"

####+END:

__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"

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

_EOF_
}


function vis_bisosGroup_bisosGid { echo 2222; }
function vis_bisosGroup_bisosGroupName { echo bisos; }

function vis_bisosAcct_bisosName { echo bisos; }
function vis_bisosAcct_bisosUid { echo 2000; }
function vis_bisosAcct_bisosGid { vis_bisosGroup_bisosGid; }
function vis_bisosAcct_bisosHome { echo "/bisos/groupAcct"; }

function vis_bisosGroupExamples {
    typeset extraInfo="-h -v -n showRun"
    #typeset extraInfo=""
    typeset runInfo="-p ri=lsipusr:passive"

    typeset examplesInfo="${extraInfo} ${runInfo}"

  cat  << _EOF_
$( examplesSeperatorChapter "BISOS Account And Group Management" )
${G_myName} ${extraInfo} -i bisosGroupVerify
${G_myName} ${extraInfo} -i bisosGroupAdd
${G_myName} ${extraInfo} -i bisosGroupDelete
${G_myName} ${extraInfo} -i bisosGroupAcctVerify
${G_myName} ${extraInfo} -i bisosGroupAcctCreate
${G_myName} ${extraInfo} -i bisosGroupAcctAdd
${G_myName} ${extraInfo} -i bisosGroupAcctDelete
_EOF_
}

function vis_bisosGroupAcctProvisionExamples {
    typeset extraInfo="-h -v -n showRun"
    #typeset extraInfo=""
    typeset runInfo="-p ri=lsipusr:passive"

    typeset examplesInfo="${extraInfo} ${runInfo}"

  cat  << _EOF_
$( examplesSeperatorChapter "Provisioning Setups" )
${G_myName}  -i bisosGroupAcctProvisionSetup   # Summary outputs
${G_myName} ${extraInfo} -i bisosGroupAcctProvisionSetup    # Detailed outputs
_EOF_
}


function vis_bisosGroupAcctProvisionSetup {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Creates bisos group and account at provisioning time.
Repeatable: 
	You can re-run this function multiple times.
Actions:
	1) Create the bisos group if it is not already in place.
	2) Create the bisos account if it is not already in place.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local bisosGroupName=$( vis_bisosGroup_bisosGroupName )
    
    if vis_bisosGroupVerify ; then
	ANT_raw "${bisosGroupName} group is as expected -- group creation skipped."
    else
	lpDo vis_bisosGroupAdd
    fi

    local bisosGroupAcctName="$( vis_bisosAcct_bisosName )"

    if vis_bisosGroupAcctVerify ; then
	ANT_raw "${bisosGroupAcctName} account is as expected -- account creation skipped."
    else
	lpDo vis_bisosGroupAcctCreate
    fi

    opDo vis_userAcctsReport ${bisosGroupAcctName}    

    lpReturn
}



function vis_bisosGroupVerify {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Verify that bisos entry exists in /etc/group and is as expected.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local bisosGroupName=$( vis_bisosGroup_bisosGroupName )
    local bisosGid=$( vis_bisosGroup_bisosGid )        
    local retVal=0

    lpDo vis_groupVerify ${bisosGroupName} ${bisosGid}
    retVal=$?
    
    lpReturn ${retVal}
}

function vis_bisosGroupAdd {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Adds bisos group, if needed.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local bisosGroupName=$( vis_bisosGroup_bisosGroupName )
    local bisosGid=$( vis_bisosGroup_bisosGid )    
    local retVal=0

    lpDo vis_groupAddAsGid ${bisosGroupName} ${bisosGid}
    retVal=$?

    lpReturn ${retVal}
}

function vis_bisosGroupDelete {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete bisos group, if needed.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local bisosGroupName=$( vis_bisosGroup_bisosGroupName )
    local retVal=0

    lpDo vis_groupsDelete ${bisosGroupName}
    retVal=$?

    lpReturn ${retVal}
}

function vis_bisosGroupAcctVerify {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Verify that the bisos account is as expected.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local acctName="$( vis_bisosAcct_bisosName )"
    local acctUid="$( vis_bisosAcct_bisosUid )"    
    local acctGid="$( vis_bisosAcct_bisosGid )"
    local acctHome="$( vis_bisosAcct_bisosHome )"    

    if ! vis_userAcctExists "${acctName}" ; then
	ANT_raw "${acctName} account entry does not exist in /etc/passwd"
	lpReturn 101
    fi
    
    if ! vis_bisosGroupVerify ; then
	EH_problem "${acctGid} group is missing or misconfigured -- Re-run bisosGroupAdd"
	lpReturn 101
    fi

    lpDo vis_accountVerify ${acctName} ${acctUid} ${acctGid} ${acctHome}
}

function vis_bisosGroupAcctCreate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Add the USG account if it does not exist.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local acctName="$( vis_bisosAcct_bisosName )"
    local acctGid="$( vis_bisosGroup_bisosGroupName )"
    

   if vis_groupExists ${acctGid} ; then    
       if ! vis_bisosGroupVerify ; then
	   EH_problem "${acctGid} group is missing or misconfigured -- Re-run bisosGroupAdd"
	   lpReturn 101
       fi
   else
       opDo vis_bisosGroupAdd
   fi

   if vis_userAcctExists "${acctName}" ; then
       if vis_bisosGroupAcctVerify ; then
	   ANT_raw "${acctName} exists and is properly configured. It will be used"
       else
	   EH_problem "${acctName} account is misconfigured"
	   lpReturn 101
       fi
   else
       opDo vis_bisosGroupAcctAdd
   fi

   opDo vis_sudoersAddLine "${acctName}" ALL NOPASSWD

   # the sudo -u ${acctName} id -- results in creation of the homeDir
   opDo vis_userAcctsReport ${acctName}   
}



function vis_bisosGroupAcctAdd {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Add the bisos account if it does not exist.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local acctName="$( vis_bisosAcct_bisosName )"
    local acctUid="$( vis_bisosAcct_bisosUid )"    
    local acctGid="$( vis_bisosGroup_bisosGroupName )"
    local acctHome="$( vis_bisosAcct_bisosHome )"
    local acctComment="BISOS Group Account"
    local supplementaryGroups="adm"  # NOTYET, locate existing code in 
    
    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

    if vis_userAcctExists "${acctName}" ; then
	EH_problem "${acctName} Already Exists -- Addition Skipped"
	lpReturn 101
    fi

    lpDo useradd \
	 --uid "${acctUid}" \
	 --gid "${acctGid}" \
	 --groups "${supplementaryGroups}" \
	 --shell /usr/sbin/nologin \
	 --no-create-home \
	 --home-dir "${acctHome}" \
	 --comment "${acctComment}" \
	 ${acctName}

    lpReturn
}

function vis_bisosGroupAcctDelete {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete the bisos account.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local acctName="$( vis_bisosAcct_bisosName )"

    lpDo vis_userAcctsDelete ${acctName}

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
