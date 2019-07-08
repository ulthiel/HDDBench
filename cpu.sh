#!/bin/bash
################################################################################
#
# Simple CPU benchmark
#
# Ulrich Thiel, 2019
# ulthiel.com/math
# mail@ulthiel.com
#
# We simply check, using bash functions only, whether some number is a prime
# number.
################################################################################

################################################################################
# Very simple function to check whether a number is a prime number.
# Efficiency is not the point here.
################################################################################
function is_prime(){
  if [[ $1 -eq 2 ]] || [[ $1 -eq 3 ]]; then
    return 1  # prime
  fi
  if [[ $(($1 % 2)) -eq 0 ]] || [[ $(($1 % 3)) -eq 0 ]]; then
    return 0  # not a prime
  fi
  i=5; w=2
  while [[ $((i * i)) -le $1 ]]; do
    if [[ $(($1 % i)) -eq 0 ]]; then
      return 0  # not a prime
    fi
    i=$((i + w))
    w=$((6 - w))
  done
  return 1  # prime
}

################################################################################
# Run a test
################################################################################
n=35184372088891 #next prime after 2^45
t=$({  time -p is_prime $n > /dev/null; } 2>&1 | grep real | awk '{print $2"s"}')

################################################################################
# Report
################################################################################
echo "-------------------------"
echo "Prime: $t"
