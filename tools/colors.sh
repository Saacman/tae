# Use colors, but only if connected to a terminal, and that terminal
# supports them.
RPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
WPATH=$RPATH/workd
mkdir $WPATH
touch $WPATH/file1