#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"

####+END:

####+BEGIN: bx:dblock:lsip:bash:seed-spec :types  "seedFtoCommon.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/opt/public/osmt/bin/seedFtoCommon.sh]] | 
"
FILE="
*  /This File/ :: /opt/bisosProvisioner/gitRepos/provisioners/bin/ftoProc.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /opt/public/osmt/bin/seedFtoCommon.sh -l $0 "$@" 
    exit $?
fi
####+END:


_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  [[elisp:(blee:ppmm:org-mode-toggle)][Nat]] [[elisp:(beginning-of-buffer)][Top]] [[elisp:(delete-other-windows)][(1)]] || Cmnd       ::  examplesHookPostExample    [[elisp:(org-cycle)][| ]]
_CommentEnd_

function examplesHookPost {
    cat  << _EOF_
$( examplesSeperatorTopLabel "EXTENSION EXAMPLES" )
$( examplesSeperatorSection "commonProc.sh -- Templates Evolution" )
diff ./commonProc.sh  /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonProcLeaf.sh
cp  ./commonProc.sh  /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonProcLeaf.sh
cp /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonProcLeaf.sh ./commonProc.sh  
$( examplesSeperatorSection "commonPanel.org -- Templates Evolution" )
diff ./commonPanel.org  /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonPanel.org
cp ./commonPanel.org /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonPanel.org
cp /libre/ByStar/InitialTemplates/start/fto/commonProc/anyFtoItem/commonPanel.org ./commonPanel.org
_EOF_
 return
}


####+BEGIN: bx:dblock:bash:end-of-file :types ""
_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  Common        ::  /[dblock] -- End-Of-File Controls/ [[elisp:(org-cycle)][| ]]
_CommentEnd_
#+STARTUP: showall
#local variables:
#major-mode: sh-mode
#fill-column: 90
# end:
####+END:

