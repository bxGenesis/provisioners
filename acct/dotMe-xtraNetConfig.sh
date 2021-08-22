#
#
#
# This file is expected to be sourced -- Not ran
#
# NOTYET, this should go in some git repo and become standrdized.
#

function flist {
    declare -f | grep ^[a-z] | cut -d ' ' -f 1
}



function extraNetActivate {
    if [ $# == 1 ] ; then
        echo $1 >  $HOME/extraNetUserPasswd     
    fi

    #
    # HTTP Proxies
    #
    echo "Invoking: extraNetProxyOn"
    extraNetProxyOn

    #
    # GIT Setup
    #
    echo "Invoking: $HOME/gitSetup.sh"
    if [ -f "$HOME/gitSetup.sh" ] ; then
        $HOME/gitSetup.sh
    elif [ -f "./gitSetup.sh" ] ; then
        ./gitSetup.sh
    else
        echo "Missing gitSetup.sh -- Skipped"
    fi
        

    #
    # PIP Setup
    #
    echo "Invoking: source $HOME/pip/dotMe-PIP-CONFIG-FILE"

    if [ -f "$HOME/pip/dotMe-PIP-CONFIG-FILE" ] ; then
        . $HOME/pip/dotMe-PIP-CONFIG-FILE       
    else
        echo "Missing $HOME/pip/dotMe-PIP-CONFIG-FILE -- Skipped"
    fi
    


}

function extraNetDeactivate {
    #
    # HTTP Proxies
    #
    echo "Invoking: extraNetProxyOn"
    extraNetProxyOn

    #
    # GIT Setup
    #
    echo "Invoking: $HOME/gitSetup.sh"
    $HOME/gitSetup.sh

    #
    # PIP Setup
    #
    echo "Invoking: source $HOME/pip/dotMe-PIP-CONFIG-FILE"     
    . $HOME/pip/dotMe-PIP-CONFIG-FILE

    return
}

function extraNetReport {

    echo "=======================USER REPORT -- Begin ======================="
    echo "extraNetUserName=$(cat $HOME/extraNetUserName)"
    echo "userName=$(cat $HOME/userName)"
    echo "userEmail=$(cat $HOME/userEmail)"    
    echo "=======================USER REPORT -- End   ======================="
    echo ""

    echo "=======================HTTP REPORT -- Begin ======================="
    local extraNetUserPasswdRaw=$(cat $HOME/extraNetUserPasswd)
    local extraNetUserPasswd=$( rawurlencode ${extraNetUserPasswdRaw} )
    extraNetProxyShow | sed -e "s:${extraNetUserPasswd}:passwd:"
  
    echo "=======================HTTP REPORT -- End   ======================="
    echo ""

    echo "=======================GIT REPORT -- Begin ======================="    
    git --no-pager config --list
    ls -l $HOME/.gitconfig      
    echo "=======================GIT REPORT -- End   ======================="
    echo ""

    echo "=======================PIP REPORT -- Begin ======================="
    echo PIP_CONFIG_FILE=${PIP_CONFIG_FILE}
    ls -l $HOME/pip/pip.config
    pip install -h | grep -i index-url    
    echo "=======================PIP REPORT -- End   ======================="
    echo ""
}

function extraNetUserPasswdSet {
    if [ $# != 4 ] ; then
        echo "E: Expected two args -- extraNetuserName extraNetuserPasswd userName userEmail"
    fi
    echo "$1" > $HOME/extraNetUserName
    echo "$2" >  $HOME/extraNetUserPasswd
    echo "$3" >  $HOME/userName
    echo "$4" >  $HOME/userEmail  
}


function extraNetUserPasswdDelete {
    rm $HOME/extraNetUserName
    rm  $HOME/extraNetUserPasswd
}


function extraNetPasswdSet {
    if [ $# != 1 ] ; then
        echo "E: Expected one arg -- userPasswd"
    fi
    echo $1 >  $HOME/extraNetUserPasswd
}


function extraNetPasswdDelete {
    rm  $HOME/extraNetUserPasswd
}

function extraNetProxyShow {
    echo http_proxy=${http_proxy}
    echo https_proxy=${https_proxy}
    echo no_proxy=${no_proxy}
    echo HTTP_PROXY=${HTTP_PROXY}
    echo HTTPS_PROXY=${HTTPS_PROXY}
}

function extraNetProxyOn {
    local userName=""
    local userPasswd=""

    if [ ! -f "$HOME/extraNetUserName" ] ; then
        echo "E: Missing $HOME/extraNetUserName -- Aborting"
        return
    fi
    if [ ! -f "$HOME/extraNetUserPasswd" ] ; then
        echo "E: Missing $HOME/extraNetUserPasswd -- Aborting"
        return
    fi

    userName=$( cat $HOME/extraNetUserName )
    userPasswd=$( cat $HOME/extraNetUserPasswd )
    userPasswdEncoded=$( rawurlencode ${userPasswd} )

    #echo ${userName} -- ${userPasswd}

    local extraNetHttpProxy=""
    local extraNetHttpsProxy=""    
    local extraNetNoProxy=""    

    extraNetHttpProxy="http://${userName}:${userPasswdEncoded}@10.10.10.10:1010"
    extraNetHttpsProxy="http://${userName}:${userPasswdEncoded}@10.10.10.10:1010"
    extraNetNoProxy="\
localhost,\
127.0.0.1,\
localaddress,\
code.example.com,\
mirrors.example.com,\
.localdomain.com,\
example.com,\
example.com,\
"
    
    export http_proxy=${extraNetHttpProxy}
    export https_proxy=${extraNetHttpsProxy}
    export no_proxy=${extraNetNoProxy}
    export HTTP_PROXY=${http_proxy}
    export HTTPS_PROXY=${https_proxy}

    export GIT_SSL_NO_VERIFY=1    
}

function extraNetProxyOff {
    unset http_proxy
    unset https_proxy
    unset no_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    
}

function rawurlencode {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

function vncStatus {
    cat ~/.vnc/*.pid
    ps -ef | grep -i tightvnc
}

function vncKill {
    tightvncserver -kill :1
}

function vncStart {
    tightvncserver -geometry 1900x1096 :1
}

