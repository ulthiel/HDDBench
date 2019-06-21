#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux/MacOS.
#
# Argument needs to be a path where test file is written to.
#
# Script is basically from https://www.amsys.co.uk/using-command-line-to-benchmark-disks/ but made some improvements and made it work under Linux as well.
#
# Ulrich Thiel, 2019
#
################################################################################

################################################################################
# Check if argument not empty
################################################################################
if [ -z "$1" ]
then
  echo "Please give path for test file to be written to as argument"
  exit 1
fi

echo "Testing $1"

################################################################################
# Determine OS (Mac and Linux behave a bit differently)
# From https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
################################################################################
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

################################################################################
# Function to purge memory
# Linux version from https://serverfault.com/questions/597115/why-drop-caches-in-linux
################################################################################
run_purge () {
  if [ "${machine}" = "Mac" ]
  then
    sudo purge
  elif [ "${machine}" = "Linux" ]
  then
    sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches
  fi
}

################################################################################
# Main program
################################################################################

# Get sudo for purging
echo "Getting sudo rights for purging memory..."
sudo ls > /dev/null

#Write test
echo "Running write test..."
write=$(dd if=/dev/zero bs=2048k of="$1"/tstfile count=1024 2>&1 | grep bytes)

#Purge
echo "Purging memory for read test..."
run_purge

#Read test
echo "Running read test..."
read=$(dd if="$1"/tstfile bs=2048k of=/dev/null count=1024 2>&1 | grep bytes)

#Cleanup
echo "Cleaning up..."
run_purge
rm "$1"/tstfile

# Report (dd output is a bit different between MacOS and Linux)
if [ "${machine}" = "Mac" ]
then
  writerep=$(echo $write | awk '{print $1 / 1000 / 1000 / $5, "MB/sec" }')
else
  writerep=$(echo $write | awk '{print $1 / 1000 / 1000 / $8, "MB/sec" }')
fi
echo "Write speed: $writerep"

if [ "${machine}" = "Mac" ]
then
  readrep=$(echo $read | awk '{print $1 / 1000 / 1000 / $5, "MB/sec" }')
else
  readrep=$(echo $read | awk '{print $1 / 1000 / 1000 / $8, "MB/sec" }')
fi
echo "Read speed: $readrep"
