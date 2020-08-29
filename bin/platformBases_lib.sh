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
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Obatin specified parameter from bx-platformInfoManage.py.
_EOF_
    }
    
    EH_assert [[ $# -eq 1 ]]

    local parName=$1
    local outVal=""

    if [ -f "${bx_platformInfoManage}" ] ; then 
	outVal=$( ${bx_platformInfoManage} -i pkgInfoParsGet | grep ${parName} | cut -d '=' -f 2 )
    fi
    echo "${outVal}"
}

function bxp_bisosUserName_get {
    local default="/bisos"
    local outVal=$( bxp_platformInfoManageVarGet "bisosUserName" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_bisosGroupName_get {
    local default="/bisos"
    local outVal=$( bxp_platformInfoManageVarGet "bisosGroupName" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_bisos_get {
    local default="/bisos"
    local outVal=$( bxp_platformInfoManageVarGet "rootDir_bisos" )
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
    local outVal=$( bxp_platformInfoManageVarGet "rootDir_deRun" )
    if [ -z "${outVal}" ] ; then
	outVal="${default}"
    fi
    echo ${outVal}
}

function bxp_rootDir_provisioners_get {
    local default="/opt/bisosProvisioner"
    local outVal=$( bxp_platformInfoManageVarGet "rootDir_provisioners" )
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

pdb_bsip_base="${bxp_rootDir_bisos}/core/bsip"
pdb_bsip_bin="${pdb_bsip_base}/bin"
pdb_bsip_lib="${pdb_bsip_base}/lib"
