#!/bin/bash
################################################################################
#
# Simple CPU benchmark
#
# Ulrich Thiel, 2019
# ulthiel.com/math
# mail@ulthiel.com

################################################################################

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

################################################################################
# Factorize a number
################################################################################
echo "Running Factorization test..."

if [ "${machine}" = "Mac" ]
then
  factor="gfactor"
else
  factor="factor"
fi

# The following number is a product of two primes
n=14016833953562607831165883451220753271

tfact=$({ time -p sh -c "$factor $n" > /dev/null; } 2>&1 | grep real | awk '{print $2"s"}')

################################################################################
# SHA256
################################################################################
echo "Running SHA256 test..."

if [ "${machine}" = "Mac" ]
then
  sha="gsha256sum"
  dd="gdd"
else
  sha="sha256sum"
  dd="dd"
fi

tsha=$({ time -p sh -c "$dd if=/dev/zero bs=1G count=10 | $sha > /dev/null" > /dev/null; } 2>&1 | grep real | awk '{print $2"s"}')

################################################################################
# Bzip
################################################################################
echo "Running Bzip test..."

if [ "${machine}" = "Mac" ]
then
  dd="gdd"
else
  dd="dd"
fi

tbzip2=$({ time -p sh -c "$dd if=/dev/zero bs=1G count=7 | bzip2 -s > /dev/null" > /dev/null; } 2>&1 | grep real | awk '{print $2"s"}')


################################################################################
# Report
################################################################################
echo "-------------------------"
echo "Factorization: $tfact"
echo "SHA256: $tsha"
echo "Bzip2: $tbzip2"
