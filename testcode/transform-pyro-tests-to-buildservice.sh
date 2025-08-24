#!/bin/bash
##
# Convert the Tests file into a file that can be run here.
#

input=$1
output=$2

if [[ "$input" == "" || "$output" == "" || "${input:0:2}" == '-h' ]] ; then
    echo "Syntax: $0 <input> <output>" >&2
    exit 1
fi

sed -E \
    -e "s!Expect: expect/pymodules/debugger!Expect: expect/debugger!" \
    -e "s!Replace: expect/pymodules/debugger!Replace: expect/debugger!" \
    -e "s!\\\$TOOL --load-internal-modules!\$TOOL!" \
    -e "s!\\\$TOOL --config messagetrans.support=[^ ]*!\$TOOL!" \
    -e "s!\\\$TOOL!\$TOOL --quiet!" \
    -e "s!bin/!bin.!" \
    < "$input" \
    > "$output"