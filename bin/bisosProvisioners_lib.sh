#!/bin/bash

#
# This file is shared between ./bisosProvisioners.sh and /usr/local/bin/bisosProvision.sh
#

thisBashFileBaseDir=$( dirname ${BASH_SOURCE[0]} )

source "${thisBashFileBaseDir}/platformBases_lib.sh"
    
#  /bisos/core/bsip/bin/bsipProvision_lib.sh
bisosBsipProvisionerLib="${pdb_bsip_bin}/bsipProvision_lib.sh"


function vis_provisioners_sysBasePlatform {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo vis_pythonSysEnvPrepForVirtenvs

    lpDo vis_updateAccts

    lpDo vis_provisionersVenvPipInstalls

    lpDo vis_bisosBaseDirsSetup   # NOTYET rename to provisionersBisosBaseDirsSetup

    lpDo vis_provisionersGitReposAnonSetup

    if [ -f "${bisosBsipProvisionerLib}" ] ; then
	source "${bisosBsipProvisionerLib}"
	lpDo vis_bsipProvision_sysBasePlatform
    else
	EH_problem "Missing ${bisosBsipProvisionerLib}"
    fi
}


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
${provisionersBinBase}/bisosBaseDirsSetup.sh
${G_myName} ${extraInfo} -i provisionersGitReposAnonSetup   # Runs as sudo -u bisos 
_EOF_
    
    if [ -f "${bisosBsipProvisionerLib}" ] ; then
	source "${bisosBsipProvisionerLib}"	
	vis_bisosProvisionExamples "${extraInfo}"
    fi
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
	
    # /opt/bisosProvisioner/gitRepos/provisioners/bin/bisosGroupAccount.sh
    local bisosProg="${provisionersBinBase}/bisosGroupAccount.sh"

    if [ ! -x "${bisosProg}" ] ; then
	EH_problem "Missing ${bisosProg}"
	lpReturn 1
    else	
    	opDo "${bisosProg}" -h -v -n showRun -i bisosGroupAcctProvisionSetup
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


function vis_provisionersGitReposAnonSetup {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
bx-gitReposBases -v 20 --baseDir="/bisos/git/anon/bxRepos" --pbdName="bxReposRoot" --vcMode="anon"  -i pbdUpdate all
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
    	opDo "${bisosProg}" -h -v -n showRun -i provisionersGitReposAnonSetup
    fi
    
    lpReturn
 }


# Use the rest till /bisos/bsip/xx is in place,
# if [ -f "${bisosBsipNotyet}" ] ; then
#     . ${something}
# fi
