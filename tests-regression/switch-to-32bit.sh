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

sudo apt-get -y remove bzip2 libcurl4-openssl-dev zlib1g-dev curl libjpeg-dev gsl-bin libgsl0-dev udunits-bin zip libsz2 libssl-dev libxml2 libxml2-dev 


echo ""
echo "Installing 32-bit dependencies"
sleep 1
sudo apt-get -y install bzip2:i386 libcurl4-openssl-dev:i386 zlib1g-dev:i386 curl:i386 libjpeg-dev:i386 gsl-bin:i386 libgsl0-dev:i386 zip:i386 libssl-dev:i386 libxml2:i386 libxml2-dev:i386 