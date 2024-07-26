#!/bin/bash -x

cd "$(dirname $(readlink -e $0))"

# read settings
source $PWD/env.sh

echo "1" > "${NAME_VAR_AUTO_ROTATE}"
