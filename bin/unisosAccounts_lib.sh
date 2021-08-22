#!/bin/bash # -*- mode: sh-mode; -*-

IcmBriefDescription="NOTYET: Short Description Of The Module"

ORIGIN="
* Revision And Libre-Halaal CopyLeft -- Part Of ByStar -- Best Used With Blee
"

####+BEGIN: bx:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+brief"

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


minUidSpec=1000
maxUidSpec=20000

function vis_unisosAccountsExamples {
    typeset extraInfo="-h -v -n showRun"
    #typeset extraInfo=""
    typeset runInfo="-p ri=lsipusr:passive"

    typeset examplesInfo="${extraInfo} ${runInfo}"

  cat  << _EOF_
$( examplesSeperatorChapter "Unisos User Accounts Management" )
${G_myName} -i uidSortPasswdFile
${G_myName} -i gidSortGroupFile
${G_myName} -p uidMinSpec=2000 -p uidMaxSpec=5000 -i uidRangePasswdFile
${G_myName} ${extraInfo} -i userAcctExists bystar ; echo \$?
$( examplesSeperatorSection "Accounts Manipulation" )
${G_myName} ${extraInfo} -i groupExists bystar ; echo \$?
${G_myName} ${extraInfo} -i userAcctExists bystar ; echo \$?
${G_myName} ${extraInfo} -i userAcctsDelete bisos bystar ; echo \$?
${G_myName} ${extraInfo} -i groupsDelete bystar ; echo \$?
$( examplesSeperatorChapter "General Purpose Accounts Processing Facilities" )
${G_myName} -i userAcctsReport bisos bystar lsipusr
${G_myName} ${extraInfo} -i userAcctsReport bystar
sudo tail /etc/sudoers
pwck
grpck
_EOF_
}

function vis_uidSortPasswdFile {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    opDo eval sort -g -t : -k 3 /etc/passwd
}

function vis_gidSortGroupFile {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    opDo eval sort -g -t : -k 3 /etc/group
}

function vis_uidRangePasswdFile {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
                       }

    local passwdLines
    local eachUid
    local each

    local sortedPasswd=$( sort -g -t : -k 3 /etc/passwd )

    readarray passwdLines <<< ${sortedPasswd}
    
    for each in "${passwdLines[@]}" ; do
        eachUid=$( echo ${each} | cut -d : -f 3 )
        if (( eachUid >= uidMinSpec )) && (( eachUid < uidMaxSpec )) ; then
            echo -n "${each}"
        fi
    done
}


function vis_userHomeAcctsDelete {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete specified user home directory.
Design Pattern: processEach based on args or stdin.
_EOF_
    }

    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local userAcctName=$1
        if ! vis_userAcctExists ${userAcctName} ; then
            EH_problem "${userAcctName} Account Does Not Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi
        local userAcctHome=$( vis_forAcctNameGetHome ${userAcctName} )
        
        lpDo sudo rm -r ${userAcctHome}
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    lpReturn
}


function vis_userHomeAcctsDefunct {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete specified user home directory.
Design Pattern: processEach based on args or stdin.
_EOF_
    }

    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local userAcctName=$1
        if ! vis_userAcctExists ${userAcctName} ; then
            EH_problem "${userAcctName} Account Does Not Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi
        local userAcctHome=$( vis_forAcctNameGetHome ${userAcctName} )
        
        lpDo sudo mv ${userAcctHome} ${userAcctHome}.defunct
        lpDo sudo chmod 000 ${userAcctHome}.defunct
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    
    lpReturn
}


function vis_userAcctsDelete {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete specified user accounts.
Design Pattern: processEach based on args or stdin.
_EOF_
    }

    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local userAcctName=$1
        if ! vis_userAcctExists ${userAcctName} ; then
            EH_problem "${userAcctName} Account Does Not Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi
        lpDo sudo userdel ${userAcctName}       
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    
    lpReturn
}

function vis_groupsAdd {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Add specified groups.
Design Pattern: processEach based on args or stdin.
Runs groupadd as root.
** TODO Modernize processEachArgsOrStdin to processEachArgsAndStdin
_EOF_
    }

    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local groupName=$1
        if vis_groupsExist ${groupName} ; then
            EH_problem "${groupName} Already Does Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi
        lpDo sudo groupadd ${groupName}         
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    lpReturn
}

function vis_groupAddAsGid {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Add specified group as specified gid.
Runs groupadd as root and returns its exitCode.
_EOF_
    }
    EH_assert [[ $# -eq 2 ]]

    local thisGroupName="$1"
    local thisGid="$2"
    local exitCode=0
    
    if vis_groupExists ${thisGroupName} ; then
        EH_problem "${groupName} Already Does Exist -- ${G_thisFunc} Processing Skipped"
        lpReturn 101
    fi
    
    lpDo sudo groupadd --gid ${thisGid} ${thisGroupName}
    exitCode=$?
    
    lpReturn ${exitCode}
}

function vis_groupsDelete {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Delete specified groups.
Design Pattern: processEach based on args or stdin.
Runs groupdel as root.
_EOF_
    }

    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local groupName=$1
        if ! vis_groupExists ${groupName} ; then
            EH_problem "${groupName} Does Not Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi
        lpDo sudo groupdel ${groupName}         
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    lpReturn
}



function vis_userAcctsReport {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Report on a user account, inputs can come from args or from stdin.
Design Pattern: processEach based on args or stdin.
Examples:
      ${G_myName} -i userAcctsReport bisos
      echo bisos bystar | ${G_myName} -i userAcctsReport
_EOF_
    }
    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local userAcctName=$1
        if ! vis_userAcctExists ${userAcctName} ; then
            EH_problem "${userAcctName} Does Not Exist -- ${thisFunc} Processing Skipped"
            lpReturn 101
        fi

        ANT_raw "--- ${userAcctName}: passwd, group, id, sudoers ---"
        
        lpDo getent passwd ${userAcctName}
        lpDo getent group ${userAcctName}

        lpDo sudo -u ${userAcctName} id
        lpDo sudo grep ${userAcctName} /etc/sudoers
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    lpReturn
}

function vis_groupVerify {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Verifies that a group is as expected.
_EOF_
    }

    EH_assert [[ $# -eq 2 ]]    

    local groupName=$1
    local groupGid=$2
    local retVal=0

    if ! vis_groupExists "${groupName}" ; then
        ANT_raw "${groupName} entry does not exist in /etc/group"
        lpReturn 101
    fi

    local getentStr=$( getent group ${groupName} )
    local getentGid=$( getent group ${groupName} | cut -d : -f 3 )

    if [ "${groupGid}" != "${getentGid}" ] ; then
        ANT_raw "GID of ${groupName} entry in /etc/group is not ${groupGid}"
        ANT_raw "${getentStr}"
        retVal=101
    fi
    lpReturn ${retVal}
}

function forAcctNameGetUid {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
For acctName return the 3rd field as uid.
_EOF_
                       }
    EH_assert [[ $# -eq 1 ]]

    forAcctNameGetFieldNu $1 3
}

function vis_forAcctNameGetHome {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
For acctName return home -- the 6th field.
_EOF_
                       }
    EH_assert [[ $# -eq 1 ]]

    forAcctNameGetFieldNu $1 6
}


function forAcctNameGetFieldNu {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Verifies that an account is as expected.
_EOF_
                       }
    EH_assert [[ $# -eq 2 ]]

    local acctName=$1
    local fieldNu=$2
    
    local getentStr=$( getent passwd ${acctName} )
    if [ -z "${getentStr}" ] ; then
        EH_problem "Missing passwd entry for ${acctName}"
        lpReturn 101
    fi
    local getentField=$( echo ${getentStr} | cut -d : -f ${fieldNu} )
    if [ -z "${getentField}" ] ; then
        EH_problem "Missing passwd field entry for ${acctName} fieldNu ${fieldNu}"
        lpReturn 101
    fi
    echo "${getentField}"
}
    


function vis_accountVerify {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Verifies that an account is as expected.
_EOF_
    }

    EH_assert [[ $# -eq 4 ]]    

    local acctName=$1
    local acctUid=$2
    local acctGid=$3
    local acctHome=$4    
    
    local retVal=0

    if ! vis_userAcctExists "${acctName}" ; then
        ANT_raw "${acctName} account entry does not exist in /etc/passwd"
        lpReturn 101
    fi

    local getentStr=$( getent passwd ${acctName} )
    local getentAcctUid=$( echo ${getentStr} | cut -d : -f 3 )
    local getentAcctGid=$( echo ${getentStr} | cut -d : -f 4 )
    local getentAcctHome=$( echo ${getentStr} | cut -d : -f 6 )    

    if [ "${acctUid}" != "${getentAcctUid}" ] ; then
        ANT_raw "UID of ${acctName} entry in /etc/passwd is not ${acctUid}"
        retVal=101
    fi
    if [ "${acctGid}" != "${getentAcctGid}" ] ; then
        ANT_raw "GID of ${acctName} entry in /etc/passwd is not ${acctGid}"
        retVal=101
    fi
    if [ "${acctHome}" != "${getentAcctHome}" ] ; then
        ANT_raw "HOME of ${acctName} entry in /etc/passwd is not ${acctHome}"
        retVal=101
    fi

    if [ "$retVal" != "0" ] ; then
        ANT_raw "${getentStr}"
    fi
    
    lpReturn ${retVal}
}


function vis_groupsReport {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Report on groups, inputs can come from args or from stdin.
Design Pattern: processEach based on args or stdin.
Examples:
      ${G_myName} -i groupsReport bisos
      echo bisos bystar | ${G_myName} -i groupsReport
_EOF_
    }
    local inputsList="$@"
    local thisFunc=${G_thisFunc}

    function processEach {
        EH_assert [[ $# -eq 1 ]]
        local groupName=$1

        if ! vis_groupExists "${groupName}" ; then
            ANT_raw "${groupName} entry does not exist in /etc/group"
            lpReturn 101
        fi

        lpDo getent group ${groupName}
    }

####+BEGIN: bx:bsip:bash/processEachArgsOrStdin 
    if [ $# -gt 0 ] ; then
        local each=""
        for each in ${inputsList} ; do
            lpDo processEach ${each}
        done
    else
        local eachLine=""
        while read -r -t 1 eachLine ; do
            if [ ! -z "${eachLine}" ] ; then
                local each=""
                for each in ${eachLine} ; do
                    lpDo processEach ${each}
                done
            fi
        done
    fi

####+END:
    
    lpReturn
}

function vis_groupExists {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Return zero if specified group exists.
Return non-zero -- exitCode of getent -- if specified group does not exist.
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    local groupNameOrGid="$1"
    local exitCode=0

    getent group ${groupNameOrGid} > /dev/null 2>&1
    exitCode=$?

    lpReturn ${exitCode}
}

function vis_sudoersAddLine {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Return zero if specified group exists.
Return non-zero -- exitCode of getent -- if specified group does not exist.
_EOF_
    }
    EH_assert [[ $# -eq 3 ]]

    local acctName="$1"
    local commands="$2"
    local passwd="$3"

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

    if egrep "^${acctName}" /etc/sudoers ; then
       ANT_raw "${acctName} is already in sudoers, skipped"
    else
        lpDo sh -c "echo ${acctName} ALL=\(ALL\) NOPASSWD: ALL >> /etc/sudoers"
    fi
}

function vis_userAcctExists {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Return zero if specified userAcct exists.
Return non-zero -- exitCode of getent -- if specified userAcct does not exist.
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    local userAcctNameOrUid="$1"
    local exitCode=0

    getent passwd ${userAcctNameOrUid} > /dev/null 2>&1
    exitCode=$?

    lpReturn ${exitCode}
}


function vis_acct_createHome {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Create home dir for specified acct -- acctHome is taken from passwd entry.
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    local acctName="$1"

    local getentStr=$( getent passwd ${acctName} )
    
    if [ -z "${getentStr}" ] ; then
        EH_problem "Missing acct -- ${acctName}"
        lpReturn 101
    fi
    
    local getentAcctUid=$( echo ${getentStr} | cut -d : -f 3 )
    local getentAcctGid=$( echo ${getentStr} | cut -d : -f 4 )
    local getentAcctHome=$( echo ${getentStr} | cut -d : -f 6 )    

    lpDo sudo mkdir -p "${getentAcctHome}"
    lpDo sudo chown ${getentAcctUid}:${getentAcctGid} "${getentAcctHome}"

    # NOTYET, Perhaps we need a feature to tighten this 
    lpDo sudo chmod g+w "${getentAcctHome}"

    lpReturn
}


function vis_acct_umaskDotProfileEnsure {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
** Ensure that for umask is properly set in ~\${acctName}/.profile. Create .profile if needed.
_EOF_
    }
    EH_assert [[ $# -eq 2 ]]

    local acctName="$1"
    local umaskValue="$2"

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;        

    local getentStr=$( getent passwd ${acctName} )
    
    if [ -z "${getentStr}" ] ; then
        EH_problem "Missing acct -- ${acctName}"
        lpReturn 101
    fi

    local getentAcctUid=$( echo ${getentStr} | cut -d : -f 3 )
    local getentAcctGid=$( echo ${getentStr} | cut -d : -f 4 )
    local getentAcctHome=$( echo ${getentStr} | cut -d : -f 6 )    

    EH_assert [ -d "${getentAcctHome}" ]

    local dotProfilePath="${getentAcctHome}/.profile"

    local effectiveUmask=$(umask)
    local filePermsOfUmaskValue=$( umask -S ${umaskValue} | sed -e s/x//g -e s/=/+/g )
    
    umask ${effectiveUmask}

    if [ ! -e "${dotProfilePath}" ] ; then
        lpDo eval cat  << _EOF_  \> "${dotProfilePath}"
#
umask ${umaskValue}
_EOF_
        lpDo chown ${getentAcctUid}:${getentAcctGid} "${dotProfilePath}"
        lpDo chmod ${filePermsOfUmaskValue} "${dotProfilePath}"
    else
        if grep "umask ${umaskValue}" "${dotProfilePath}" ; then
            ANT_raw "umask is already properly set"
        else
            lpDo eval cat  << _EOF_  \>\> "${dotProfilePath}"
#
umask ${umaskValue}
_EOF_
        fi
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
