


function vis_provisionersExamples {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]
    
    local extraInfo="$1"

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
$( examplesSeperatorChapter "BISOS Provisioning:: Selfcontained ICMs Invocations" )
$( examplesSeperatorSection "Create Accounts" )
${G_myName} ${extraInfo} -i updateAccts
$( examplesSeperatorSection "Create BisosProv Virtenvs" )
${G_myName} ${extraInfo} -i pythonSysEnvPrepForVirtenvs
$( examplesSeperatorSection "Create /bisos Bases" )
${G_myName} ${extraInfo} -i bisosBaseDirsSetup
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

    local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
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

    local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
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

    local selfcontainedBase=$( vis_basedOnGitDetermineThisSelfcontainedBase 2> /dev/null )
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
    
    if [ -z "${thisGitRoot}" ] ; then
	provisionersBinBase="/opt/bisosProvisioner/gitRepos/provisioners/bin"
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

function vis_pythonSysEnvPrepForVirtenvs {
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
    	opDo "${bisosProg}" -h -v -n showRun -i venvPipInstalls
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
