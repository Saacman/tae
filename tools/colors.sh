# Use colors, but only if connected to a terminal, and that terminal
# supports them.
_func() {
  return 1
}
_eda_install_main() {
  sudo -v # ask for sudo password up-front
while true; do
  # Update user's timestamp without running a command
  sudo -nv; sleep 1m
  # Exit when the parent process is not running any more. In fact this loop
  # would be killed anyway after being an orphan(when the parent process
  # exits). But this ensures that and probably exit sooner.
  kill -0 $$ 2>/dev/null || exit
done &

  set -e
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

  printf "${BLUE}${BOLD}%s${NORMAL}\n" "To keep up on the latest news and updates"
  printf "${BLUE}Using the Oh My Bash template file and adding it to ~/.bashrc${NORMAL}\n"
  printf "${YELLOW}Found ~/.bashrc.${NORMAL} ${GREEN}Backing up to $bashrc_backup${NORMAL}\n"
  printf "${RED}Text in red${NORMAL} ${GREEN}Backing up to $bashrc_backup${NORMAL}\n"
func && echo "No error" || printf "${RED}${BOLD}ERROR${NORMAL}\n" && exit 1

echo "No error"

}

_eda_install_main