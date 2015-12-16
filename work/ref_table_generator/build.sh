#!/bin/sh

./generate_ref.lua

TEX_CMD=pdflatex

$TEX_CMD chordsRef.tex
$TEX_CMD chordsRefCZ.tex

rm *.dvi *.log *.aux
