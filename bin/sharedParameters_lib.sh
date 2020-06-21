#!/bin/bash

#
# This file is sourced by related bisosProvisioner scripts.
#

provisionersBaseDir="/opt/bisosProvisioner"

venvBasePy2="${provisionersBaseDir}/venv/py2"
venvBasePy3="${provisionersBaseDir}/venv/py3"    


function vis_rootDirProvisionersGet {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local rootDir_provisioners=$( bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_provisioners | cut -d '=' -f 2 )

    if [ -z "${rootDir_provisioners}" ] ; then
	EH_problem "Missing rootDir_provisioners in bx-platformInfoManage.py"
    fi
    echo "${rootDir_provisioners}"
}



function vis_basedOnGitDetermineThisSelfcontainedBase {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
echo someParam and args 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    #
    # seed sets up thisGitRoot=$( cd $(dirname $0); git rev-parse --show-toplevel 2> /dev/null )
    #

    inBaseDirDo ${thisGitRoot}/../.. pwd
}
