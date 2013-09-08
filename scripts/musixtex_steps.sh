#!/bin/sh

#
# Three steps are required to type notes.
#
# 1. tex file.tex -> it creates file file.mx1
#
# 2. musixflx file.tex -> it creates file file.mx2
#
# 3. tex file.tex -> it creates final dvi file
#
# We add 0 step to remove file.mx?
#
# 0. rm -f file.mx?

if [ ! $# -eq 2 ] ; then
    echo "Usage:";
    echo "$0 dvi|pdf file_prefix";
    echo -e "\n dvi|pdf determines destination output format. For DVI is used etex command. For PDF is used pdfetex command."
    echo " file_prefix is file name without suffix .tex"
    exit -1;
fi


#TEX_CMD=pdfcsplain # output in pdf
TEX_CMD=pdfetex # output in pdf
if [ $1 = "dvi" ] ; then
#    TEX_CMD=csplain
    TEX_CMD=etex
fi

file_prefix=`basename $2 .tex`;


if [ ! -f $file_prefix.tex ] ; then
    echo "Error: File $file_prefix.tex does not exist!";
    exit -1;
fi

rm -f $file_prefix.mx?

$TEX_CMD $file_prefix;

if [ ! $? -eq 0 ]
then
    echo "Error: $TEX_CMD failed!"
    exit -1;
fi

musixflx $file_prefix;

$TEX_CMD $file_prefix;
