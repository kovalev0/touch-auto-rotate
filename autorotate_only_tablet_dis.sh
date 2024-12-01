#!/bin/bash

cd "$(dirname $(readlink -e $0))"

# read settings
source $PWD/env.sh

echo "0" > "${NAME_VAR_AUTO_ROTATE_ONLY_TABLET}"
