#
# Perhaps some aspects should become distro specific. 
#

[[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
[[ ":$PATH:" != *":.:"* ]] && export PATH=".:${PATH}"

if [ -d "/usr/local/go" ] ; then
    export PATH="/usr/local/go/bin:~/go/bin:${PATH}"
fi

#export JAVA_HOME=/usr/lib/jvm/java-8-oracle

#set history=100
alias clear='tput clear'
alias lsf='ls --color -C -F'
alias -- 0='dirs'
alias -- +='pushd'
alias -- -='popd'
#alias ls='ls --color'
#LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
#export LS_COLORS
