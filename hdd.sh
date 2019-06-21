#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux and MacOS.
#
# You will have to enter a path for the test file to be written to. This can
# also be passed as argument to the script.
#
# This script uses dd on Linux and the equivalent gdd from the coreutils on
# MacOS. The MacOS native dd behaves a bit differently and has less options.
# If you don't have gdd installed, you need to do "brew install coreutils".
#
# Ulrich Thiel, 2019
# ulthiel.com/math
# mail@ulthiel.com
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
# Get OS (Linux and Mac behave a bit differently)
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
# Correct dd command
################################################################################
if [ "${machine}" = "Mac" ]
then
  ddcmd=gdd
else
  ddcmd=dd
fi

################################################################################
# Function to clean memory
################################################################################
drop_cache () {
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
write=$($ddcmd if=/dev/zero of="$path"/.hddtstfile bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $10 $11 }')

#Clean memory
echo "Cleaning memory for read test..."
drop_cache

#Read test
echo "Running read test..."
read=$($ddcmd if="$path"/.hddtstfile of=/dev/null bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $10 $11 }')

#Cleanup
echo "Cleaning up..."
#drop_cache
rm "$path"/.hddtstfile

# Report
echo "Write speed: $write"
echo "Read speed: $read"
