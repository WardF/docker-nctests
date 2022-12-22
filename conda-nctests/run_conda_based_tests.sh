#!/bin/bash

set -e
# set -x

if [ "$DOHELP" != "" ]; then
    cat "${HOME}"/README.md
    exit 0
fi

##
# Function to copy artifacts from /workdir to  /artifacts
##
publish_artifacts () {
    ARTTARG=${ARTDIR}/${TKEY}-artifacts
    mkdir -p "${ARTTARG}"
    echo "Generating Artifacts"
    # Were the AC-based artifacts generated? If not, skip
    if [ "${USEAC}" = "TRUE" ] || [ "${USEAC}" = "ON" ]; then
        if [ "${DISTCHECK_C}" = "TRUE" ] || [ "${DISTCHECK_C}" = "ON" ]; then
            echo "Copying archive artifacts to ${ARTTARG}"
            cp "${TARG_BUILD_AC_CDIR}"/*.tar.gz "${TARG_BUILD_AC_CDIR}"/*.zip "${ARTTARG}"/
        elif [ "${DIST_C}" = "TRUE" ] || [ "${DIST_C}" = "ON" ]; then
            echo "Copying archive artifacts to ${ARTTARG}"
            cp "${TARG_BUILD_AC_CDIR}"/*.tar.gz "${TARG_BUILD_AC_CDIR}"/*.zip "${ARTTARG}"/
        fi
    fi

}

##
# Set some environmental variables
##


TKEY="$(date +%m%d%y%H%M%S)"
TARGSUFFIX="$(pwd)/${TKEY}-artifacts"
TARGINSTALL="${TARGSUFFIX}"

mkdir -p "${TARGSUFFIX}"
TARG_SRC_CDIR="${TARGSUFFIX}"/netcdf-c-src
TARG_BUILD_AC_CDIR="${TARGSUFFIX}"/netcdf-c-ac-build
TARG_BUILD_CMAKE_CDIR="${TARGSUFFIX}"/netcdf-c-cmake-build

export CFLAGS="-I${CONDA_PREFIX}/include -I${TARGINSTALL}/include"
export LDFLAGS="-L${CONDA_PREFIX}/lib -L${TARGINSTALL}/lib"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CONDA_PREFIX}/lib:${TARGINSTALL}/lib"
export PATH="${TARGINSTALL}/bin:${PATH}"
export CC=${USE_CC}

##
# Install some conda packages
##

conda install -c conda-forge hdf5 ncurses cmake bison make zip unzip autoconf automake libtool libxml2 -y

##
# Set some more environmental Variables
##


##
# NetCDF-C Process
#
# o Run cmake-based tests
# o Run autoconf-based tests
#   o (optional) run distcheck
#   
##

#
# Check out source code.
#
git clone https://www.github.com/Unidata/netcdf-c --single-branch --branch "${CBRANCH}" --depth 1 "${TARG_SRC_CDIR}"

#
# CMake-based tests
#

if [ "${USECMAKE}" != "FALSE" ]; then
    mkdir -p "${TARG_BUILD_CMAKE_CDIR}"

    cd "${TARG_BUILD_CMAKE_CDIR}" && cmake "${TARG_SRC_CDIR}" -DCMAKE_C_COMPILER="${USE_CC}" -DCMAKE_C_FLAGS="${CFLAGS}" && make -j "${TESTPROC}" && ctest -j "${TESTPROC}"
fi

#
# End CMake
# 

#
# Autoconf-based tests
#  - Out of directory build for autoconf-based tools, and also do distcheck.
#

if [ "${USEAC}" = "TRUE" ] || [ "${USEAC}" = "ON" ]; then

    mkdir -p "${TARG_BUILD_AC_CDIR}"
   
    cd "${TARG_SRC_CDIR}" && autoreconf -if && cd "${TARG_BUILD_AC_CDIR}" && CC="${USE_CC}" "${TARG_SRC_CDIR}"/configure --prefix="${TARGINSTALL}" && make check -j "${TESTPROC}" TESTS="" && make check -j "${TESTPROC}" && make install -j "${TESTPROC}"

    if [ "${DISTCHECK_C}" = "TRUE" ] || [ "${DISTCHECK_C}" = "ON" ]; then
        cd "${TARG_BUILD_AC_CDIR}" && make distcheck -j "${TESTPROC}"
    elif [ "${DIST_C}" = "TRUE" ] || [ "${DIST_C}" = "ON" ]; then
        cd "${TARG_BUILD_AC_CDIR}" && make dist -j "${TESTPROC}"
    fi


fi
#
# End Autoconf
#

##
# Publish artifacts. Checks for which artifacts to publish are made
# in the function itself
##
publish_artifacts


echo "!!!!! TODO: CREATE SUMMARY OUTPUT FILE !!!!!"