#!/bin/sh

if [ ! $# -eq 2 ] ; then
    echo "Usage:";
    echo "$0 dvi|pdf file_prefix";
    echo -e "\n dvi|pdf determines destination output format. For DVI is used tex command. For PDF is used pdftex command."
    echo " file_prefix is file name without suffix .pmx"
    exit -1;
fi

file=$2
fileBase=`basename $file .pmx`

pmx_chords.sh $fileBase
if [ ! $? -eq 0 ]
then
    echo "pmx_chords process fail!"
    exit -1
fi
musixtex_steps.sh $1 $fileBase
