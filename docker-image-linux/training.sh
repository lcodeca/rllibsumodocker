#!/bin/bash

# Example of learning script for RLLIB + SUMO Utlis
#
# Author: Lara CODECA
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.

set -e

# SUMO-dev environmental vars
export SUMO_HOME="/home/alice/sumo"
export SUMO_BIN="$SUMO_HOME/bin"
export SUMO_TOOLS="$SUMO_HOME/tools"
export PATH="$SUMO_BIN:$PATH"

echo "Testing SUMO command:"
sumo --version

echo "Testing Tensorflow resources:"
python tf-gpu-test.py

echo "Testing RLLIB SUMO Utils example:"
python /home/alice/libraries/rllibsumoutils/example/ppotrain.py
