#!/bin/bash # -*- mode: sh-mode; -*-

IimBriefDescription="Linux Ports Bash Library"


__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"

. ${opLibBase}/pidLib.sh                 # PID Library Is Needed

function forPortGetProcessId {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    #if vis_reRunAsRoot G_thisFunc $@ ; then lpReturn globalReRunRetVal; fi;

    local portNu="$1"

    local pid=$(sudo fuser -n tcp  "${portNu}" 2> /dev/null)

    echo ${pid}

    lpReturn
}	


function vis_forPortFullReport {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -gt 0 ]]

    #if vis_reRunAsRoot G_thisFunc $@ ; then lpReturn globalReRunRetVal; fi;

    local portNu=""

    local pid=""

    for each in "$@" ; do
	portNu="${each}"
	pid=$(forPortGetProcessId "${portNu}")

	if [ -z "${pid}" ] ; then
	    #ANT_raw "No Process Is Running On Port ${portNu}"
	    ANT_raw "====== PortNu=${portNu} -- No Process Running =======" 	    
	    continue
	fi

	ANT_raw "====== PortNu=${portNu} -- PID=${pid} ======="

	opDo forPidGetCmndline ${pid}

	opDo forPidGetCwd ${pid}
    done

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
