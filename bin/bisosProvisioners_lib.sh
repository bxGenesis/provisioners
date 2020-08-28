#!/bin/bash

#
# This file is shared between ./bisosProvisioners.sh and /usr/local/bin/bisosProvision.sh
#

_CommentBegin_
****** TODO Add blee symlinks
****** TODO Add git clone auth as well
****** TODO Drive this for development
_CommentEnd_


####+BEGIN: bx:dblock:global:file-insert :mode "bash" :file "/bisos/core/bsip/bin/platformBases_lib.sh"
#
# This File: platformBases_lib.sh
#

#
# This file is shared between ./provisionBisos.sh and /usr/local/bin/bisosProvision.sh
#
# It sets up variables prefixed with bxp_  (BISOS Platform) all mapping to bx-platformInfoManage.py
#
# Then based on bxp_ s derived variable are prefixed as pdb_ (platform dir bases)
#

bxp_currentUser=$( id -un )
bxp_currentUserGroup=$( id -g -n ${currentUser} )

bx_platformInfoManage=$( which -a bx-platformInfoManage.py | grep -v venv | head -1 )

function bxp_platformInfoManageVarGet {
    EH_assert [[ $# -eq 1 ]]

    local varName=$1
    local outVal=""

    if [ -f "${bx_platformInfoManage}" ] ; then 
	outVal=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep ${varName} | cut -d '=' -f 2 )
    fi
    echo "${outVal}"
}

function bxp_bisosUserName_get {
    local default="/bisos"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "bisosUserName" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_bisosGroupName_get {
    local default="/bisos"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "bisosGroupName" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_bisos_get {
    local default="/bisos"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "rootDir_bisos" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_bxo_get {
    local default="/bxo"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "rootDir_bxo" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_deRun_get {
    local default="/de/run"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "rootDir_deRun" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_provisioners_get {
    local default="/opt/bisosProvisioner"
    local outVal=""
    outVal=$( bxp_platformInfoManageVarGet "rootDir_provisioners" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

bxp_bisosUserName="$( bxp_bisosUserName_get )"
bxp_bisosGroupName="$( bxp_bisosGroupName_get )"
    
bxp_rootDir_bisos="$( bxp_rootDir_bisos_get )"
bxp_rootDir_bxo="$( bxp_rootDir_bxo_get )"
bxp_rootDir_deRun="$( bxp_rootDir_deRun_get )"

bxp_rootDir_provisioners="$( bxp_rootDir_provisioners_get )"


#
# pdb_ (Platform Dir Bases)
#

venvBasePy2="${bxp_rootDir_provisioners}/venv/py2"
venvBasePy3="${bxp_rootDir_provisioners}/venv/py3"    

pdb_bsipBase="${bxp_rootDir_bisos}/core/bsip"

#
# /bisos/venv/py2-bisos-3  /bisos/venv/py2/bisos3 /bisos/venv/dev/py2/bisos3
# /bisos/venv/dev-py2-bisos-3
#
pdb_venv_py2Bisos3="${bxp_rootDir_bisos}/venv/py2-bisos-3"
pdb_venv_py2Bisos3Dev="${bxp_rootDir_bisos}/venv/dev-py2-bisos-3"
pdb_venv_py3Bisos3="${bxp_rootDir_bisos}/venv/py3-bisos-3"
pdb_venv_py3Bisos3Dev="${bxp_rootDir_bisos}/venv/dev-py3-bisos-3"

####+END

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


function provisionerBisosBinBaseGet {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    local provisionersBinBase=""
    local bxp_rootDir_bisos="${rootDir_bisos}"

    if [ -z "${bxp_rootDir_bisos}" ] ; then
	EH_problem "Blank bxp_rootDir_bisos"
	lpReturn 101
    elif [ -d "${bxp_rootDir_bisos}/core/bsip/bin" ] ; then
	provisionersBinBase="${bxp_rootDir_bisos}/core/bsip/bin"
    else
	EH_problem "Missing ${bxp_rootDir_bisos}/core/bsip/bin"
	lpReturn 101
    fi

    echo ${provisionersBinBase}
}


provisionerBisosBinBaseGet="$( provisionerBisosBinBaseGet )"    
    
#  /bisos/core/bsip/bin/bisosProvision_lib.sh
bisosBsipProvisionerLib="${provisionerBisosBinBaseGet}/bisosProvision_lib.sh"

if [ -f "${bisosBsipProvisionerLib}" ] ; then
    source "${provisionerBisosBinBaseGet}/platformBases_lib.sh"
    source "${bisosBsipProvisionerLib}"
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
${provisionersBinBase}/bisosBaseDirsSetup.sh
${G_myName} ${extraInfo} -i provisionersGitReposAnonSetup   # Runs as sudo -u bisos 
_EOF_
    
    osmtTmpExamples "${extraInfo}"

    if [ -f "${bisosBsipProvisionerLib}" ] ; then
	vis_bisosProvisionExamples "${extraInfo}"
	echo "__________KKK________"
    fi


}

function osmtTmpExamples {
   G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]
    
    local extraInfo="$1"
    local provisionersBinBase="$( provisionersBinBaseGet )"

    cat  << _EOF_    
$( examplesSeperatorChapter "Temporary OSMT Setup" )
$( examplesSeperatorSection "Run OSMT Genesis" )
${provisionersBinBase}/osmtBx2GenesisSelfcontained.sh
${G_myName} ${extraInfo} -i osmtGenesis baseIoC
${G_myName} ${extraInfo} -i osmtGenesis baseIoC atNeda
$( examplesSeperatorChapter "BISOS Bases Administration (/bisos/core)" )
$( examplesSeperatorSection "bisosBasesAdmin" )
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


# Use the rest till /bisos/bsip/xx is in place,
# if [ -f "${bisosBsipNotyet}" ] ; then
#     . ${something}
# fi
