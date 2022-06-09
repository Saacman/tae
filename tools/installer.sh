#!/bin/sh
LIST_OF_APPS="netgen-lvs ngspice ngpsice-doc git make"
MAGIC_DEP="m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev"
mkdir using
cd using
cwd=$(pwd)

# Installing apps using apt
sudo apt update && sudo apt-get install --assume-yes $LIST_OF_APPS

#Install magic requiered by tech file
sudo apt-get install --assume-yes $MAGIC_DE
git clone git://opencircuitdesign.com/magic
cd magic
./configure
make
sudo make install

# Installing the pdk
git clone git://opencircuitdesign.com/open_pdks
git clone https://github.com/google/skywater-pdk
cd $cwd/skywater-pdk
git submodule init libraries/sky130_fd_io/latest
git submodule init libraries/sky130_fd_pr/latest
git submodule init libraries/sky130_fd_sc_hd/latest
git submodule update
make timing
cd $cwd/open_pdks/
./configure --enable-sky130-pdk=$cwd/skywater-pdk
make
sudo make install

make distclean

cd ../$cwd
rm -rf $cwd