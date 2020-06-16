#!/bin/bash

#
# This file is sourced by related bisosProvisioner scripts.
#

provisionersBaseDir="/opt/bisosProvisioner"

venvBasePy2="${provisionersBaseDir}/venv/py2"
venvBasePy3="${provisionersBaseDir}/venv/py3"    

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
