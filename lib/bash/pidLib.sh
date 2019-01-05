#!/bin/bash 

IimBriefDescription="Linux PID Bash Library"

__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"

function forPidGetCmndline {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    #if vis_reRunAsRoot G_thisFunc $@ ; then lpReturn globalReRunRetVal; fi;

    local pid="$1"
    local cmndLine=$(cat /proc/${pid}/cmdline | tr '\000' ' ')

    # Needed -- otherwise cat of /proc/${pid}/cmdline is missing newline
    echo ${cmndLine}

    lpReturn
}	


function forPidGetCwd {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    #if vis_reRunAsRoot G_thisFunc $@ ; then lpReturn globalReRunRetVal; fi;

    local pid="$1"
    
    readlink -e  /proc/${pid}/cwd
    # pwdx ${pid}

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
