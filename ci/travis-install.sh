# Copyright (c) 2016-present, Gregory Szorc
# All rights reserved.
#
# This software may be modified and distributed under the terms
# of the BSD license. See the LICENSE file for details.

# This shell scripts sets up the Travis CI build environment.

# If a Conda build, download and install Conda.
if [ "${BUILDMODE}" = "conda" ]; then
    if [ "${TRAVIS_PYTHON_VERSION}" = "2.7" ]; then
        wget -O miniconda.sh https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh
    else
        wget -O miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh
    fi

    bash miniconda.sh -b -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    hash -r
    conda config --set always_yes yes --set changeps1 no
    conda update -q conda
    conda install conda-build

    conda create -n test-environment python=$TRAVIS_PYTHON_VERSION
    source activate test-environment
elif [ "${BUILDMODE}" = "macoswheels" ]; then
    pip2 install --require-hashes -r ci/requirements.macoswheels.txt
elif [ "${BUILDMODE}" = "manylinuxwheels" ]; then
    echo "no installation necessary when generating manylinux wheels"
else
    pip install --require-hashes -r ci/requirements.txt
fi
