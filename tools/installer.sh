#!/bin/sh
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if hash tput >/dev/null 2>&1; then
  local ncolors=$(tput colors 2>/dev/null || tput Co 2>/dev/null || echo -1)
fi
if [[ -t 1 && -n $ncolors && $ncolors -ge 8 ]]; then
  local RED=$(tput setaf 1 2>/dev/null || tput AF 1 2>/dev/null)
  local GREEN=$(tput setaf 2 2>/dev/null || tput AF 2 2>/dev/null)
  local YELLOW=$(tput setaf 3 2>/dev/null || tput AF 3 2>/dev/null)
  local BLUE=$(tput setaf 4 2>/dev/null || tput AF 4 2>/dev/null)
  local BOLD=$(tput bold 2>/dev/null || tput md 2>/dev/null)
  local NORMAL=$(tput sgr0 2>/dev/null || tput me 2>/dev/null)
else
  local RED=""
  local GREEN=""
  local YELLOW=""
  local BLUE=""
  local BOLD=""
  local NORMAL=""
fi

LIST_OF_APPS="netgen-lvs ngspice ngspice-doc git make build-essential"
MAGIC_DEP="m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev"

mkdir using
cd using
cwd=$(pwd)

sudo -v # ask for sudo password up-front
while true; do
  # Update user's timestamp without running a command
  sudo -nv; sleep 1m
  # Exit when the parent process is not running any more. In fact this loop
  # would be killed anyway after being an orphan(when the parent process
  # exits). But this ensures that and probably exit sooner.
  kill -0 $$ 2>/dev/null || exit
done &

# Installing apps using apt
sudo apt update && sudo apt-get install --assume-yes $LIST_OF_APPS $MAGIC_DEP

# Cloning needed repos
git clone git://opencircuitdesign.com/magic
git clone git://opencircuitdesign.com/open_pdks
git clone https://github.com/google/skywater-pdk

# Installing magic
cd magic
./configure
make
sudo make install

# Installing the pdk

cd $cwd/skywater-pdk # Setting up the pdk
git submodule init libraries/sky130_fd_io/latest
git submodule init libraries/sky130_fd_pr/latest
git submodule init libraries/sky130_fd_sc_hd/latest
git submodule update
make timing

cd $cwd/open_pdks/ # Adding to /usr
./configure --enable-sky130-pdk=$cwd/skywater-pdk
make
sudo make install

make distclean

cd
rm -rf $cwd

set +e

  # MOTD message :)
  printf '%s' "$GREEN"
  printf '%s\n' \
'__/\\\\\\\\\\\\\\\_____/\\\\\\\\\_____/\\\\\\\\\\\\\\\_        '\
' _\///////\\\/////____/\\\\\\\\\\\\\__\/\\\///////////__       '\
'  _______\/\\\________/\\\/////////\\\_\/\\\_____________      '\
'   _______\/\\\_______\/\\\_______\/\\\_\/\\\\\\\\\\\_____     '\
'    _______\/\\\_______\/\\\\\\\\\\\\\\\_\/\\\///////______    '\
'     _______\/\\\_______\/\\\/////////\\\_\/\\\_____________   '\
'      _______\/\\\_______\/\\\_______\/\\\_\/\\\_____________  '\
'       _______\/\\\_______\/\\\_______\/\\\_\/\\\\\\\\\\\\\\\_ '\
'        _______\///________\///________\///__\///////////////__'\
'All tools and the PDK are now instaled!'
