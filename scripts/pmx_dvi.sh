#!/bin/sh
pmx_full.sh dvi $1

# use xdvi to show result
xdvi -s 4 $1
