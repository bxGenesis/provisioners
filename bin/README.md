# OVERVIEW

This directory contains tools that are common to building, running and
testing bxBootstrap in its entirety and individually.

All these bash and python tools share common code and common features
and common capabilities that are briefly described below.

## COMMON BASH SCRIPTS CAPABILITIES AND MODEL

All scripts in this directory can be executed from anywhere.
This directory is expected to have been added to your PATH, perhaps like so:

``` shell
export PATH="/opt/bxBootstrap/gitRepos/bxBootstrap/tools/common/bin:${PATH}"
```

Where /opt/bxBootstrap/gitRepos/ is expected to be a symlink to 
the base of this git repo.

When running the scripts from a git repo which is different from 
what /opt/bxBootstrap/gitRepos/ points to, the root of that git repo 
becomes effective and /opt/bxBootstrap/gitRepos/ is ignored.

All scripts in this directory run ./seedIcmStandalone.bash as:

``` shell
if [ "${loadFiles}" == "" ] ; then
    "${mainRepoRoot}/bxBootstrap/tools/common/bin/seedIcmStandalone.bash" -l $0 "$@" 
    exit $?
fi
```

As a result the scripts become "Bash ICMs (Interactive Command Modules)".

This means that any bash function definitions which start with "vis_" (for visable)
in their name (for example vis_someAction) become invokable at command line with "-i someAction.

``` shell
function vis_someAction {
    echo "Param: someParam=${someParam}"
    echo "Args: $@"
        return
}
```

Options, parameters and arguments are then passed to the vis_someAction.

All getopt and other preparations happen in seedIcmStandalone.bash and 
are not repeated in each module.

As an example run:

``` shell
bashIcmExample.sh -h -v -n showRun -p someParam=someValue -i someAction arg1 arg2
```

## COMMON PYTHON SCRIPTS CAPABILITIES AND MODEL

A super-set of bash ICM capabilities is also implemented in python
using unisos.icm module.

All python scripts in this directory are based on the unisos.icm.

So, all scripts in this directory are ICMs and they all follow the same 
command-line syntax and model.


# RELIANCE ON /opt/bxBootstrap BASE

Towards productizing bxBootstrap services, /opt/bxBootstrap has been extended.

Needed directory structures in /opt/bxBootstrap/ are created and maintained with 
./bxBootstrapRunEnvBases.py.

# SUPPORTED DISTROs

These scripts determine what distro they are running on and execute 
relevant specific pieces for that distro -- if needed.

The following distros are supported:

* fedora
* centos
* suse
* ubuntu


# MANIFEST (Files And Directory Structure)

## ./bashIcmExample.sh

New scripts should use ./bashIcmExample.sh as starting point template.

## ./seedIcmStandalone.bash

A seed that provides getopt, command-line to bash function mapping, logging, tracing and 
exception handling.

# Authors

Mohsen BANAN

Last Updated: Jan 3, 2019
