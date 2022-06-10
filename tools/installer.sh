#!/bin/sh
# Using wget
# bash -c "$(wget https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh -O -)"
# Using curl
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh)"
_eda_install_tools() {
  # Installing apps using apt
  sudo apt update &&
  sudo apt-get install --assume-yes $LIST_OF_APPS $MAGIC_DEP ||
  { printf "${RED}${BOLD}ERROR: There is a problem with apt${NORMAL}\n" && exit 1; }
  return 0
}

_eda_install_magic() {
  git clone git://opencircuitdesign.com/magic || 
  git clone https://github.com/RTimothyEdwards/magic || 
  { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone magic repo${NORMAL}\n" && exit 1; }
  MAGIC_PATH=$RPATH/magic
  cd $MAGIC_PATH
  ./configure && make -C $MAGIC_PATH && sudo make -C $MAGIC_PATH install ||
  { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to set up magic repo${NORMAL}\n" && exit 1; }
  rm -rf $MAGIC_PATH
  cd ~
  return 0
}

_eda_setup_skywater() {
  git clone https://github.com/google/skywater-pdk || { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone skywater-pdk repo${NORMAL}\n" && exit 1; }
  SKY_PATH=$RPATH/skywater-pdk # Setting up the pdk
  cd $SKY_PATH
  git submodule init libraries/sky130_fd_io/latest
  git submodule init libraries/sky130_fd_pr/latest
  git submodule init libraries/sky130_fd_sc_hd/latest
  git submodule update
  make -C $SKY_PATH timing || { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}There is an error with the pdk timing${NORMAL}\n" && exit 1; }
  cd $RPATH
  return 0
}

_eda_install_pdk() {
  git clone git://opencircuitdesign.com/open_pdks ||
  git clone https://github.com/RTimothyEdwards/open_pdks ||
  { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone Open_PDKs repo${NORMAL}\n" && exit 1; }
  OPENPDK_PATH=$RPATH/open_pdks
  cd $OPENPDK_PATH
  ./configure --enable-sky130-pdk=$RPATH/skywater-pdk && make -C $OPENPDK_PATH && sudo make -C $OPENPDK_PATH install ||
  { printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}There is a error ${NORMAL}\n" && exit 1; }
  make -C $OPENPDK_PATH distclean
  echo "export PDK_ROOT=\"/usr/local/share/pdk\"" >> ~/.bashrc
  echo "export PDK_PATH=\"$PDK_ROOT/sky130A\"" >> ~/.bashrc
  echo "alias magicsky=\"magic -T $PDK_PATH/libs.tech/magic/sky130A.tech\"" >> ~/.bashrc
  source ~/.bashrc
  cd ~
}

_eda_do_all() {
  _eda_install_tools && printf "${BLUE}Done installing netgen & ngspice${NORMAL}\n"
  _eda_install_magic && printf "${BLUE}Done installing magic${NORMAL}\n"
  _eda_setup_skywater && printf "${BLUE}Done setting up the pdk for install${NORMAL}\n"
  _eda_install_pdk && printf "${BLUE}Done installing the pdk${NORMAL}\n"
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
  exit
}

_eda_run_main() {
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
  local RPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
  
  # Extending sudo timeout
  sudo -v # ask for sudo password up-front
  while true; do
    # Update user's timestamp without running a command
    sudo -nv; sleep 1m
    # Exit when the parent process is not running any more. In fact this loop
    # would be killed anyway after being an orphan(when the parent process
    # exits). But this ensures that and probably exit sooner.
    kill -0 $$ 2>/dev/null || exit
  done &

  while :
do
    cat<<EOF
    ===============================
    Welcome to the EDA setup script
    -------------------------------
    Please enter your choice:
    Option (0) Install & setup everything (First Run Only!)
    Option (1) Install NGSpice & Netgen
    Option (2) Install magic
    Option (3) Install the PDK
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "0")  _eda_do_all ;;
    "1")  _eda_install_tools ;;
    "2")  _eda_install_magic ;;
    "3")  _eda_setup_skywater ;;
    "Q")  exit                ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
 
}
_eda_run_main