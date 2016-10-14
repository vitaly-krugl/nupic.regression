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

# Install what's necessary on top of raw Ubuntu for testing a NuPIC wheel.
#
# NOTE much of this will eventually go into a docker image


set -o errexit
set -o xtrace

# Prepare environment
if [ -z "${USER}" ]; then
    USER="docker"
fi
export USER

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install OS dependencies, assuming stock ubuntu:latest
apt-get update
apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python \
    python2.7 \
    python2.7-dev
    apt-utils \
    python2.7 \
    python2.7-dev \
    libffi-dev \
    libssl-dev \
    curl \
    build-essential \
    openssl

update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --set python /usr/bin/python2.7


#
# Install and start mysql (needed for integration and swarming tests)
#

# Install, suppressing prompt for admin password, settling for blank password
DEBIAN_FRONTEND=noninteractive \
  debconf-set-selections <<< 'mysql-server mysql-server/root_password password'

DEBIAN_FRONTEND=noninteractive \
  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password'

DEBIAN_FRONTEND=noninteractive \
  apt-get -y install mysql-server

# Start mysql server
/usr/bin/mysqld_safe &


#
# Install pip/setuptools
#
set -o errexit
set -o xtrace

# Tool requirements:
#   Fleshed out PEP-508 support (Dependency Specification)
_PIP_VER="8.1.2"
_SETUPTOOLS_VER="25.2.0"

# Download get-pip.py
curl --silent --show-error --retry 5 -O http://releases.numenta.org/pip/1ebd3cb7a5a3073058d0c9552ab074bd/get-pip.py

python get-pip.py "$@" --ignore-installed \
  pip==${_PIP_VER} \
  setuptools==${_SETUPTOOLS_VER} \

python -c 'import pip; print "pip version=", pip.__version__'
python -c 'import setuptools; print "setuptools version=", setuptools.__version__'


# Hack to resolve SNIMissingWarning
pip install urllib3[secure]

# We use this for one regression test
pip install automatatron

# Set up NAB
git clone https://github.com/numenta/NAB.git --depth 50
export NAB="${MY_DIR}/NAB"
echo "Installing NAB..."
(cd ${NAB} && python setup.py install --user)

# Install nupic
pip install nupic-*.whl
