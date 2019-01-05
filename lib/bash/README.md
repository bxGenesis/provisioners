# OVERVIEW

This directory contains bash libraries that are used in 
bash scripts in ../../bin and elsewhere.


# MANIFEST (Files And Directory Structure)

## ./distrosLib.sh

Based on /etc/os-release provide distro-name, version, family, etc.

## ./mainRepoRootDetermine.bash

Code fragment to be included in all bash ICMs through dblock.
Determines if we are within git repo or not.

## ./seedIcmLoad.bash

Code fragment to be included in all bash ICMs through dblock.


## ./portLib.sh

Monitors tcp ports and maps them to processes

## ./pidLib.sh

given a pid determines commandLine and cwd.

# Authors

Mohsen BANAN

Last Updated: Jan. 4, 2019
