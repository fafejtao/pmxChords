#!/bin/sh

DEST_DIR=~/texmf/tex/musixtex/pmxChords

mkdir -p $DEST_DIR
cp  texmf/*.tex $DEST_DIR

texhash
