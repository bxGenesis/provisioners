


function vis_provisionersExamples {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]
    
    local extraInfo="$1"

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
