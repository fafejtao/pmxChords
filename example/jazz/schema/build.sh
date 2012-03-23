#!/bin/bash

BUILD_DIR=tmp

file_prefix=$1
pmx_file=$file_prefix.pmx

if [ ! -f $pmx_file ] ; then
	echo "File $pmx_file does not exist."
	exit -1
fi

#
# copy the file to build directory
#
mkdir -p $BUILD_DIR
cp $pmx_file $BUILD_DIR
cd $BUILD_DIR

dest_tex_file_prefix=$file_prefix-final
dest_tex_file=$dest_tex_file_prefix.tex

# clear the destination tex file
echo "" > $dest_tex_file

#
# create schema in all transpositions
#
transposed_file=$file_prefix-trans
for TP in "%" "K-3+1" "K+3-1" "K+1+2" "K-1-2" "K-2+3" "K+2-3" "K+2+4" "K-2-4"
do
# replace %K-3+1 to required transposition and call perl script for chord transposition
sed -e "/^%K-3+1/c$TP" $pmx_file | chords_transpose.pl > $transposed_file.pmx
# create tex file
pmxab $transposed_file

# 
# append each file to dest_tex_file
sed -r "/\\\endmuflex|^\\\bye/d" $transposed_file.tex >> $dest_tex_file

done

#
# append end of file
#
echo "\vfill\eject\endmuflex" >> $dest_tex_file
echo "\bye" >> $dest_tex_file


#
# create PDF result

musixtex_steps.sh pdf $dest_tex_file_prefix



