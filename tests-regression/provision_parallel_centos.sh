#!/bin/bash

set -e
cd /root

export PATH=/usr/lib64/openmpi/bin:$PATH
export PATH=/usr/lib64/mpich/bin:$PATH

###
# Manually install hdf4 so that we can run
# those tests as well.
###

tar -jxf /root/hdf-4.2.15.tar.bz2 && cd /root/hdf-4.2.15 && CC=mpicc CFLAGS="-I/usr/include/tirpc" LDFLAGS="-L/usr/lib64" LIBS="-ltirpc" ./configure --disable-static --enable-shared --disable-netcdf --disable-fortran --prefix=/usr && make -j 8 && make install

cd /root
rm -rf /root/hdf-4.2.15


###
# Manually install hdf5 so that we can run
# those tests as well.
###

CFLAGS="-Wno-format-security"
tar -jxf /root/hdf5-1.10.8.tar.bz2 && cd /root/hdf5-1.10.8 && CC=mpicc ./configure --disable-static --enable-shared --disable-fortran --enable-hl --prefix=/usr --with-szlib --enable-parallel && make -j 8 && make install

cd /root
rm -rf /root/hdf5-1.10.8

###
# Manually install pnetcdf so that we can
# run pnetcdf tests.
###

tar -zxf /root/pnetcdf-1.11.0.tar.gz && cd /root/pnetcdf-1.11.0 && CPPFLAGS=-fPIC CC=mpicc ./configure --prefix=/usr --disable-fortran --enable-relax-coord-bound && make -j 8 -k && make install

cd /root
rm -rf pnetcdf-1.11.0
sudo ldconfig
