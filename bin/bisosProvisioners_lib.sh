#!/bin/bash

#
# This file is shared between ./bisosProvisioners.sh and /usr/local/bin/bisosProvision.sh
#

currentUser=$(id -un)
currentUserGroup=$(id -g -n ${currentUser})


bx_platformInfoManage=$( which -a bx-platformInfoManage.py | grep -v venv | head -1 )


bisosUserName=""
bisosGroupName=""
    
rootDir_bisos=""
rootDir_bxo=""
rootDir_deRun=""

rootDir_provisioners=""

venvBasePy2=""
venvBasePy3=""


if [ -f "${bx_platformInfoManage}" ] ; then 
    bisosUserName=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep bisosUserName | cut -d '=' -f 2 )
    bisosGroupName=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep bisosGroupName | cut -d '=' -f 2 )
    
    rootDir_bisos=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
    rootDir_bxo=$( ${bx_platformInfoManage}  -i pkgInfoParsGet | grep rootDir_bxo | cut -d '=' -f 2 )
    rootDir_deRun=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep rootDir_deRun | cut -d '=' -f 2 )        

    rootDir_provisioners=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep rootDir_provisioners | cut -d '=' -f 2 )

    venvBasePy2="${rootDir_provisioners}/venv/py2"
    venvBasePy3="${rootDir_provisioners}/venv/py3"    
fi


function vis_provisionersExamples {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]
    
    local extraInfo="$1"
    local provisionersBinBase="$( provisionersBinBaseGet )"

    cat  << _EOF_    
$( examplesSeperatorChapter "BISOS Provisioning Configuration:: Platform Information" )
bx-platformInfoManage.py    
$( examplesSeperatorSection "bx-platformInfoManage.py :: Get And Set Parameters" )
bx-platformInfoManage.py  -i pkgInfoParsGet
bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_provisioners | cut -d '=' -f 2
bx-platformInfoManage.py -v 20 --rootDir_provisioners="/opt/bisosProvisioner"  -i pkgInfoParsSet
_EOF_

    cat  << _EOF_
$( examplesSeperatorChapter "Development Feature:: Git Enable, Activate, Prep" )
${G_myName} ${extraInfo} -i gitReposReport
$( examplesSeperatorSection "Git Auth (Development) Setups" )
${G_myName} ${extraInfo} -i gitPrepAuth
${G_myName} ${extraInfo} -i gitActivateAuth
${G_myName} ${extraInfo} -i gitEnableAuth
$( examplesSeperatorSection "Git Anon (Released) Setups" )
${G_myName} ${extraInfo} -i gitPrepAnon
${G_myName} ${extraInfo} -i gitActivateAnon
_EOF_
    
    cat  << _EOF_
$( examplesSeperatorChapter "BISOS Provisioning:: SelfReliant ICMs Invocations" )
$( examplesSeperatorSection "Sys Install Pythons And Pips And Sys Packages" )
${provisionersBinBase}/bisosSysPythonSetup.sh
${G_myName} ${extraInfo} -i pythonSysEnvPrepForVirtenvs
$( examplesSeperatorSection "Create Accounts" )
${provisionersBinBase}/bisosAccounts.sh
${G_myName} ${extraInfo} -i updateAccts
$( examplesSeperatorSection "Create BisosProv Virtenvs And Install Packages" )
${provisionersBinBase}/bisosProvisionersVenvSetup.sh
${G_myName} ${extraInfo} -i provisionersVenvPipInstalls
$( examplesSeperatorSection "Create /bisos Bases" )
${provisionersBinBase}/bisosBaseDirsSetup.sh
${G_myName} ${extraInfo} -i bisosBaseDirsSetup
$( examplesSeperatorSection "Anon Git Clone BxRepos" )
(. activateFile; bx-gitReposBases )
sudo -u bisos ${G_myName} ${extraInfo} -i bxGitReposBasesAnon
$( examplesSeperatorSection "Run OSMT Genesis" )
${provisionersBinBase}/osmtBx2GenesisSelfcontained.sh
${G_myName} ${extraInfo} -i osmtGenesis baseIoC
${G_myName} ${extraInfo} -i osmtGenesis baseIoC atNeda
_EOF_
}


function vis_gitReposReport {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
If needed, git auth clone.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    #local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
    local selfcontainedBase=$( vis_rootDirProvisionersGet 2> /dev/null )    
    local gitReposBase="${selfcontainedBase}/gitRepos"    

    lpDo ls -l "${gitReposBase}"/*
    
    lpReturn
}


function vis_gitPrepAuth {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Git Auth clone/update and activate.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo vis_gitEnableAuth

    lpDo vis_gitActivateAuth    
    
    lpReturn
}


function vis_gitEnableAuth {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
If needed, git auth clone.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
    local selfcontainedBase=$( vis_rootDirProvisionersGet 2> /dev/null )        
    local gitReposAuthBase="${selfcontainedBase}/gitReposAuth"
    local thisRepoDir="${gitReposAuthBase}/provisioners"

    lpDo mkdir -p "${gitReposAuthBase}"

    if [ -d "${thisRepoDir}" ] ; then
	ANT_raw "${thisRepoDir} exists -- git clone skipped"
    else
	inBaseDirDo "${gitReposAuthBase}" git clone git@github.com:bxGenesis/provisioners.git
    fi

    lpReturn
}

function vis_gitActivateAuth {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Update the symlink from gitRepos to point to gitReposAuth.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
    local selfcontainedBase=$( vis_rootDirProvisionersGet 2> /dev/null )        
    local gitReposAuthBase="${selfcontainedBase}/gitReposAuth"
    local gitReposBase="${selfcontainedBase}/gitRepos"    

    opDo FN_fileSymlinkUpdate "${gitReposAuthBase}/provisioners" "${gitReposBase}/provisioners" 

    lpReturn
}


function vis_gitPrepAnon {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Git Auth clone/update and activate.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo vis_gitActivateAnon    

    lpReturn
}


function vis_gitActivateAnon {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Update the symlink from gitRepos to point to gitReposAnon.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
    local selfcontainedBase=$( vis_rootDirProvisionersGet 2> /dev/null )            
    local gitReposAnonBase="${selfcontainedBase}/gitReposAnon"
    local gitReposBase="${selfcontainedBase}/gitRepos"    

    opDo FN_fileSymlinkUpdate "${gitReposAnonBase}/provisioners" "${gitReposBase}/provisioners" 

    lpReturn
}




function provisionersBinBaseGet {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase=""
    local provisionersRootDir="$( vis_rootDirProvisionersGet )"
    
    if [ -z "${thisGitRoot}" ] ; then
	# /opt/bisosProvisioner/gitRepos/provisioners/bin
	provisionersBinBase="${provisionersRootDir}/gitRepos/provisioners/bin"
    else
	provisionersBinBase="${thisGitRoot}/bin"
    fi

    echo ${provisionersBinBase}
}
    

function vis_updateAccts {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase="$( provisionersBinBaseGet )"
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/bisosAccounts.sh
    local bisosProg="${provisionersBinBase}/bisosAccounts.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else	
    	opDo "${bisosProg}" -h -v -n showRun -i fullUpdate passwd_tmpSame
    fi
    
    lpReturn
}

function vis_pythonSysEnvPrepForVirtenvs {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase="$( provisionersBinBaseGet )"
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/bisosSysPythonSetup.sh
    local bisosProg="${provisionersBinBase}/bisosSysPythonSetup.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else	
    	opDo "${bisosProg}" -h -v -n showRun -i pythonSysEnvPrepForVirtenvs
    fi
    
    lpReturn
}

function vis_provisionersVenvPipInstalls {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase="$( provisionersBinBaseGet )"
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/bisosProvisionersVenvSetup.sh
    local bisosProg="${provisionersBinBase}/bisosProvisionersVenvSetup.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else	
    	opDo "${bisosProg}" -h -v -n showRun -i fullUpdate
    fi
    
    lpReturn
}


function vis_bisosBaseDirsSetup {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase="$( provisionersBinBaseGet )"
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/bisosBaseDirsSetup.sh
    local bisosProg="${provisionersBinBase}/bisosBaseDirsSetup.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else	
    	opDo "${bisosProg}" -h -v -n showRun -i bisosBaseDirsSetup
    fi
    
    lpReturn
}


function vis_bxGitReposBasesAnon {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
bx-gitReposBases -v 20 --baseDir="/bisos/git/anon/bxRepos" --pbdName="bxReposRoot" --vcMode="anon"  -i pbdUpdate all
_EOF_
    }
    # EH_assert [[ $# -eq 1 ]]

    # local bisosRootDir=$1

    local py2ActivateFile="${venvBasePy2}/bin/activate"

    source ${py2ActivateFile}
    
    lpDo bx-gitReposBases -v 20 --baseDir="/bisos/git/anon/bxRepos" --pbdName="bxReposRoot" --vcMode="anon"  -i pbdUpdate all
}




function vis_osmtGenesis {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -ge 0 ]]

    local icmArgs="$@"

    local provisionersBinBase="$( provisionersBinBaseGet )"
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/osmtBx2GenesisSelfcontained.sh
    local bisosProg="${provisionersBinBase}/osmtBx2GenesisSelfcontained.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else
	osmtBx2GenesisSelfcontained.sh -h -v -n showRun -r basic -i baseIoC            # Blee + Ability To Import Io
    	opDo sudo "${bisosProg}"  -h -v -n showRun -r basic -i $@
    fi
    
    lpReturn
}
