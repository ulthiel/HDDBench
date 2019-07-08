#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux and macOS.
#
# Ulrich Thiel, 2019
# ulthiel.com/math
# mail@ulthiel.com
#
# You will have to enter a path for the test file to be written to. This can
# also be passed as argument to the script.
#
# This script uses dd.
#
################################################################################

################################################################################
# Options
################################################################################
bs=1G #block size
count=2 #number of blocks

################################################################################
# Get path for test file
################################################################################
if [ -z "$1" ]
then
  read -p "Path for test file (e.g. /tmp): " path
else
  path="$1"
  echo "Testing $path"
fi

################################################################################
# Get OS
################################################################################
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# dd command
if [ "${machine}" = "Mac" ]
then
  dd="gdd"
else
  dd="dd"
fi

################################################################################
# Function to flush and clean caches
################################################################################
flush () {
  sync
  echo "Flushing caches (needs sudo)..."
  if [ "${machine}" = "Mac" ]
  then
    sudo purge
  else
    sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
  fi
}

################################################################################
# Main program
################################################################################
file="$path/.hddtstfile"

flush

echo "Running write test..."
write=$($dd if=/dev/zero of=$file bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $(NF-1)$(NF)}')

flush

echo "Running read test..."
read=$($dd if=$file of=/dev/null bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $(NF-1)$(NF)}')

flush
rm $file

# Report
echo "-------------------------"
echo "Write speed: $write"
echo "Read speed: $read"
echo "-------------------------"
