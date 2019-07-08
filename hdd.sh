#!/bin/bash
################################################################################
#
# Determine HDD write/read speed under Linux and macOS.
#
# You will have to enter a path for the test file to be written to. This can
# also be passed as argument to the script.
#
# This script uses dd. The macOS native dd has slightly different output and we
# have to take care of this.
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
# Function to clean memory
################################################################################
clean_mem () {
  sync
  echo "Cleaning memory (needs sudo)..."
  if [ "${machine}" = "Mac" ]
  then
    sudo purge
  elif [ "${machine}" = "Linux" ]
  then
    sudo echo 3 > /proc/sys/vm/clean_mems
  fi
}

################################################################################
# Main program
################################################################################

# on macOS dd needs lower case block size; on Linux upper case...
if [ "${machine}" = "Mac" ]
then
  bs=`echo "$bs" | tr '[:upper:]' '[:lower:]'`
  count=`echo "$count" | tr '[:upper:]' '[:lower:]'`
elif [ "${machine}" = "Linux" ]
then
  bs=`echo "$bs" | tr '[:lower:]' '[:upper:]'`
  count=`echo "$count" | tr '[:lower:]' '[:upper:]'`
fi

file="$path/.hddtstfile"

# Write test
# The conv=fdatasync seems ensures that all data is really written before dd
# quits and reports speed
echo "Running write test..."
sync
if [ "${machine}" = "Mac" ]
then
  output=$({ time -p sh -c "dd if=/dev/zero of="$file" bs=$bs count=$count 2>&1 && sync";} 2>&1)
  bytes=$(echo $output | awk '{print $7}')
  time=$(echo $output | awk '{print $16}')
  write=$(echo "scale=2; $bytes / 1000 / 1000 / $time;" | bc -l)
  write=$(echo $write MB/s)
elif [ "${machine}" = "Linux" ]
then
  write=$(dd if=/dev/zero of=$file bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $(NF-1)$(NF)}')
fi

# Clean memory
# If we don't do this, then read will be done from cache and we don't want
# this of course
clean_mem

# Read test
echo "Running read test..."
if [ "${machine}" = "Mac" ]
then
  output=$({ time -p sh -c "dd if=$file of=/dev/null bs=$bs count=$count 2>&1 && sync";} 2>&1)
  bytes=$(echo $output | awk '{print $7}')
  time=$(echo $output | awk '{print $16}')
  read=$(echo "scale=2; $bytes / 1000 / 1000 / $time;" | bc -l)
  read=$(echo $read MB/s)
elif [ "${machine}" = "Linux" ]
then
  read=$(dd if=$file of=/dev/null bs=$bs count=$count conv=fdatasync 2>&1 | grep bytes | awk '{print $(NF-1)$(NF)}')
fi

# Cleanup
echo "Cleaning up..."
clean_mem
rm $file

# Report
echo "-------------------------"
echo "Write speed: $write"
echo "Read speed: $read"
echo "-------------------------"
