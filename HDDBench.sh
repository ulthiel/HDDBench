#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux/MacOS.
#
# Argument needs to be a path where test file is written to.
#
# Script is basically from https://www.amsys.co.uk/using-command-line-to-benchmark-disks/
#
# Ulrich Thiel, 2019
#
################################################################################

################################################################################
# Function to purge memory
################################################################################
run_purge () {
  # Determine OS for correct purging command
  # From https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac

  if [ "${machine}" == "Mac" ]
  then
    sudo purge
  else
    #from https://serverfault.com/questions/597115/why-drop-caches-in-linux
    sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches
  fi
}

################################################################################
# Main program
################################################################################

# Check if argument not empty
if [ -z "$1" ]
then
  echo "Please give path for test file to be written to as argument"
  exit 1
fi

# Need sudo to purge
echo "Getting sudo rights for purging memory..."
[ "$UID" -eq 0 ] || sudo ls > /dev/null

#Write test
echo "Testing $1"
echo "Running write test..."
write=$(dd if=/dev/zero bs=2048k of="$1"/tstfile count=1024 2>&1 | grep sec | awk '{print $1 / 1024 / 1024 / $5, "MB/sec" }')
echo "Write speed: $write"

#Purge
echo "Purging memory for read test..."
run_purge

#Read test
echo "Running read test..."
read=$(dd if="$1"/tstfile bs=2048k of=/dev/null count=1024 2>&1 | grep sec | awk '{print $1 / 1024 / 1024 / $5, "MB/sec" }')
echo "Read speed: $read"

#Cleanup
echo "Cleaning up..."
run_purge
rm "$1"/tstfile
