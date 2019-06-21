#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux and MacOS.
#
# You can pass as first argument a path for the test file to be written to.
#
# Script is basically from
# https://www.amsys.co.uk/using-command-line-to-benchmark-disks/.
# I made some improvements and made it work under Linux as well.
# Important is "purging" to avoid distortion by caching.
#
# Ulrich Thiel, 2019
# ulthiel.com/math
# math@ulthiel.com
#
################################################################################

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
# Well will use dd for the benchmark.
# The output of dd on Linux is a tiny bit different than on MacOS.
# To parse correctly, we have to distinguish this.
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
    sudo sync && sudo purge
  elif [ "${machine}" = "Linux" ]
  then
    sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches
  fi
}

################################################################################
# Main program
################################################################################

# Get sudo for purging
echo "Getting sudo rights for cleaning memory..."
sudo ls > /dev/null

#Write test
echo "Running write test..."
if [ "${machine}" = "Mac" ]
then
  write=$(dd if=/dev/zero of="$path"/.hddtstfile bs=2048k count=1024 conv=sync 2>&1 | grep bytes)
else
  write=$(dd if=/dev/zero of="$path"/.hddtstfile bs=2048k count=1024 conv=fdatasync 2>&1 | grep bytes)
fi

#Purge
echo "Cleaning memory for read test..."
#run_purge

#Read test
echo "Running read test..."
if [ "${machine}" = "Mac" ]
then
  read=$(dd if="$path"/.hddtstfile of=/dev/null bs=2048k count=1024 conv=sync 2>&1 | grep bytes)
else
  read=$(dd if="$path"/.hddtstfile of=/dev/null bs=2048k count=1024 conv=fdatasync 2>&1 | grep bytes)
fi

#Cleanup
echo "Cleaning up..."
#run_purge
rm "$path"/.hddtstfile

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
