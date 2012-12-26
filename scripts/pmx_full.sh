#!/bin/sh

if [ ! $# -eq 2 ] ; then
    echo "Usage:";
    echo "$0 dvi|pdf file_prefix";
    echo -e "\n dvi|pdf determines destination output format. For DVI is used tex command. For PDF is used pdftex command."
    echo " file_prefix is file name without suffix .tex"
    exit -1;
fi

file_prefix=$2

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

musixtex_steps.sh $1 $TEX_ENC_FILE

# rename destination file file-tex.dvi to file.dvi
if [ -f $TEX_ENC_FILE.dvi ] ; then
    mv $TEX_ENC_FILE.dvi $file_prefix.dvi
fi

# rename destination file file-tex.pdf to file.pdf
if [ -f $TEX_ENC_FILE.pdf ] ; then
    mv $TEX_ENC_FILE.pdf $file_prefix.pdf
fi
