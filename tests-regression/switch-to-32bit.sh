#!/bin/bash
# Enable 32-bit builds.  
# Uninstall 64-bit dependencies.
# Install 32-bit

set -e 

echo "Adding i386 Architecture"
sleep 1

sudo dpkg --add-architecture i386
sudo apt update

echo ""
echo "Removing 64-bit dependencies"
sleep 1

sudo apt-get -y remove bzip2 libcurl4-openssl-dev zlib1g-dev curl libjpeg-dev zip libsz2 libssl-dev libxml2-dev curl cmake libtool automake autoconf m4 bison flex libaec0 libaec-dev


echo ""
echo "Installing 32-bit dependencies"
sleep 1
sudo apt-get -y install gcc-multilib
sudo apt-get -y install bzip2:i386 libcurl4-openssl-dev:i386 zlib1g-dev:i386 curl:i386 libjpeg-dev:i386 zip:i386 libssl-dev:i386 libxml2:i386 libxml2-dev:i386 cmake:i386 g++:i386 gfortran:i386 automake:i386 autoconf:i386 m4:i386 bison:i386 flex:i386
sudo apt-get -y install zlib1g-dev:i386 zlib1g:i386


echo ""
echo "Cleaning up lingering libsz2"
sleep 1
find /usr -name 'libsz*' -exec sudo rm {} \;

echo ""
echo "Installing libaec manually"
sleep 1
echo ""
wget https://swprojects.dkrz.de/redmine/attachments/download/453/libaec-0.3.2.tar.gz
tar -zxf libaec-0.3.2.tar.gz
cd libaec-0.3.2
CFLAGS="-m32" ./configure --disable-static --enable-shared --prefix=/usr
make -j 4
sudo make install -j 4
cd ..
sudo ldconfig