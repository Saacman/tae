#!/bin/sh
bash -c "$(wget https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh -O -)"

_eda_install_tools() {
  # Installing apps using apt
  sudo apt update &&
  sudo apt-get install --assume-yes $LIST_OF_APPS $MAGIC_DEP ||
  printf "${RED}${BOLD}ERROR: There is a problem with apt${NORMAL}\n" && return 1
  return 0
}

_eda_install_magic() {
  git clone git://opencircuitdesign.com/magic || 
  git clone https://github.com/RTimothyEdwards/magic || 
  printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone magic repo${NORMAL}\n" && return 1
  cd $cwd/magic
  ./configure && make && sudo make install  printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone skywater-pdk repo${NORMAL}\n" && return 1
  return 0
}

_eda_setup_skywater() {
  git clone https://github.com/google/skywater-pdk || printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone skywater-pdk repo${NORMAL}\n" && return 1
  cd $cwd/skywater-pdk # Setting up the pdk
  git submodule init libraries/sky130_fd_io/latest
  git submodule init libraries/sky130_fd_pr/latest
  git submodule init libraries/sky130_fd_sc_hd/latest
  git submodule update
  make timing || printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}There is an error with the pdk timing${NORMAL}\n" && return 1
  return 0
}

_eda_install_pdk() {
  git clone git://opencircuitdesign.com/open_pdks ||
  git clone https://github.com/RTimothyEdwards/open_pdks ||
  printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}Unable to clone Open_PDKs repo${NORMAL}\n" && exit 1
  cd $cwd/open_pdks/ # Adding to /usr
  ./configure --enable-sky130-pdk=$cwd/skywater-pdk && make && sudo make install ||
  printf "${RED}${BOLD}ERROR:${NORMAL} ${YELLOW}There is a big error here${NORMAL}\n" && exit 1
  make distclean
}

_eda_do_all() {
  _eda_install_tools || printf "${BLUE}Fix the error with apt and continue from option 2${NORMAL}\n" && exit 1
  _eda_install_magic || printf "${BLUE}Fix the error with magic and continue from option 3${NORMAL}\n" && exit 1
  _eda_setup_skywater || printf "${BLUE}Get help to setup the pdk${NORMAL}\n" && exit 1
  _eda_install_pdk || printf "${BLUE}Get help to install the pdk${NORMAL}\n" && exit 1
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
  _eda_clean
  exit
}
_eda_clean() {
  # Cleaning
  cd ~
  rm -rf $cwd
  exit 0
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

  set -e
  cd ~
  [ -d workd ] && rm -rf workd
  mkdir workd && cd workd || printf "${RED}${BOLD}ERROR: You have no writing permissions${NORMAL}\n" && exit 1
  local cwd=$(pwd)
  
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
    clear
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
    "1")  _eda_install_tools || exit 1 ;;
    "2")  _eda_install_magic || exit 1 ;;
    "3")  _eda_setup_skywater && _eda_install_pdk || exit 1 ;;
    "Q")  _eda_clean                ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
 
}
_eda_run_main