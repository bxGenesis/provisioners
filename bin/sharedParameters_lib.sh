#!/bin/bash

#
# This file is sourced by related bisosProvisioner scripts.
#


currentUser=$(id -un)
currentUserGroup=$(id -g -n ${currentUser})


bx_platformInfoManage=$( which -a bx-platformInfoManage.py | grep -v venv | head -1 )

if [ ! -f "${bx_platformInfoManage}" ] ; then 
    EH_problem  "Missing ${bx_platformInfoManage}"
    lpReturn 101
fi
    
bisosUserName=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep bisosUserName | cut -d '=' -f 2 )
bisosGroupName=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep bisosGroupName | cut -d '=' -f 2 )
    
rootDir_bisos=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
rootDir_bxo=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep rootDir_bxo | cut -d '=' -f 2 )
rootDir_deRun=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep rootDir_deRun | cut -d '=' -f 2 )        

rootDir_provisioners=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep rootDir_provisioners | cut -d '=' -f 2 ) 


venvBasePy2="${rootDir_provisioners}/venv/py2"
venvBasePy3="${rootDir_provisioners}/venv/py3"    


# function vis_rootDirProvisionersGet {
#     G_funcEntry
#     function describeF {  G_funcEntryShow; cat  << _EOF_
# echo someParam and args 
# _EOF_
#     }
#     EH_assert [[ $# -eq 0 ]]

#     if [ -z "${rootDir_provisioners}" ] ; then
# 	EH_problem "Missing rootDir_provisioners in bx-platformInfoManage.py"
#     fi
#     echo "${rootDir_provisioners}"
# }


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
