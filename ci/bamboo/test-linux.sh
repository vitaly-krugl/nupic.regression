#!/bin/bash
# ----------------------------------------------------------------------
# Numenta Platform for Intelligent Computing (NuPIC)
# Copyright (C) 2016, Numenta, Inc.  Unless you have purchased from
# Numenta, Inc. a separate commercial license for this software code, the
# following terms and conditions apply:
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero Public License for more details.
#
# You should have received a copy of the GNU Affero Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# http://numenta.org/licenses/
# -----------------------------------------------------------------------------
#
# Run NuPIC tests on Linux.
#
# OUTPUTS:
#
# test results: nupic junit test results will be written to the file
#               nupic-test-results.xml in the root of the nupic source tree.
#
# code coverage report: in tests/htmlcov and tests/.coverage

set -o errexit
set -o xtrace

#
# Test
#

# Some tests require NUPIC env var to locate config files.
# Some nupic config files reference USER env var, so it needs to be defined.

# Run tests with pytest options per nupic.core/setup.cfg. The "|| true" is added
# at the end cause it prevents test failures from returning non-zero exit status
pushd NAB
export NAB=$(pwd)
python run.py -d numenta,numentaTM --detect --score --normalize --skipConfirmation
popd

NUPIC=$(cd nupic && pwd) \
USER=$(whoami) \
py.test tests || true
