#!/bin/bash

cd "$(dirname $(readlink -e $0))"

# read settings
source $PWD/env.sh

monitor-sensor > "${NAME_VAR_ORIENTATION}"
