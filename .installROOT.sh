#!/bin/bash
# CERN ROOT install script builds cmake and then ROOT

#Check if running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

# Install dependecies
sudo apt-get install -y build-essential checkinstall
sudo apt-get install -y dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
sudo apt-get install -y xorg
sudo apt-get install -y git
sudo apt-get install -y python-dev

## Install CMAKE
cd /tmp
wget http://www.cmake.org/files/v3.12/cmake-3.12.4.tar.gz
tar xf cmake-3.12.4.tar.gz
cd cmake-3.12.4
./configure
make -j
make install
cd ..
rm -r cmake-3.12.4.tar.gz cmake-3.12.4

## Create Install location
mkdir /usr/local/root
cd /usr/local/root

## Clone and build
git clone http://root.cern.ch/git/root.git
cmake ./root
cmake --build . -- -j8

