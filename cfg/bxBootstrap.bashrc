#
# Perhaps some aspects should become distro specific. 
#

export PATH="/opt/cible/gitRepos/i2deploy/cible/tools/common/bin:${PATH}"

if [ -d "/usr/local/go" ] ; then
    export PATH="/usr/local/go/bin:~/go/bin:${PATH}"
fi

export JAVA_HOME=/usr/lib/jvm/java-8-oracle

