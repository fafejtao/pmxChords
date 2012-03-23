#!/bin/sh

file_prefix=$1

if [ ! -f $file_prefix.pmx ] ; then
	echo "File $file_prefix.pmx does not exist."
	exit -1
fi

TEX_ENC_FILE=${file_prefix}-tex
cat $file_prefix.pmx | chords_transpose.pl > $TEX_ENC_FILE.pmx
# cstocs utf8 tex $file_prefix.pmx | chords_transpose.pl > $TEX_ENC_FILE.pmx

pmxab $TEX_ENC_FILE
if [ ! $? -eq 0 ]
then
    echo "PMX process fail!"
    exit -1
fi

musixtex_steps.sh dvi $TEX_ENC_FILE
if [ ! $? -eq 0 ]
then
    echo "TeX process fail!"
    exit -1
fi

xdvi -s 4 $TEX_ENC_FILE
