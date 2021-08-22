#!/bin/bash 

IcmLibBriefDescription="Linux Distros Bash Library"

__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"
__NOTYET__="
** apply the distro_id pattern to all functions in this module.
"

function distro_id {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    #local distroId=$(grep '^ID=' /etc/os-release | awk -F= '{ print $2 }' | sed -e 's: ::g')
    local distroId=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2)

    #
    # At this point value of distroId is quoted. 
    # We unquote it with eval -- only needed for older versions of bash/echo
    # With the eval, eurolos fails.
    # 
    eval echo ${distroId}

    lpReturn
}       


function distro_versionId {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local distroVersionId=$(grep '^VERSION_ID=' /etc/os-release | awk -F= '{ print $2 }' | sed -e 's: ::g')

    eval echo ${distroVersionId}

    lpReturn
}       

function distro_familyId {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local distroFamilyId=$(grep '^ID_LIKE=' /etc/os-release | awk -F= '{ print $2 }' | sed -e 's: ::g')

    eval echo ${distroFamilyId}

    lpReturn
}       



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
