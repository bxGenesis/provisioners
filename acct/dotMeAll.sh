#
# This BLOCK is machine generated by acctSetup.sh 
#
# BLOCK Begins
# 

if [ -f "$HOME/dotMe-xtraNetConfig.sh" ]; then
    . "$HOME/dotMe-xtraNetConfig.sh"
elif [ -f "./dotMe-xtraNetConfig.sh" ]; then
    . "./dotMe-xtraNetConfig.sh"
else
    echo "E: Missing $HOME/dotMe-xtraNetConfig.sh"
fi

if [ -f "$HOME/dotMe-userBashrc.sh" ]; then
    . "$HOME/dotMe-userBashrc.sh"
elif [ -f "./dotMe-userBashrc.sh" ]; then
    . "./dotMe-userBashrc.sh"
else
    echo "E: Missing $HOME/dotMe-userBashrc.sh"
fi

if [ -f "$HOME/dotMe-someProj.sh" ]; then
    . "$HOME/dotMe-someProj.sh"
elif [ -f "./dotMe-someProj.sh" ]; then
    . "./dotMe-someProj.sh"
else
    echo "E: Missing $HOME/dotMe-someProj.sh"
fi
