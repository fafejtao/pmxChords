#!/bin/sh

groovy generate_ref.groovy > chordsRef.tex
groovy generate_ref.groovy 1 > chordsRefCZ.tex

TEX_CMD=pdflatex

$TEX_CMD chordsRef.tex
$TEX_CMD chordsRefCZ.tex


rm *.dvi *.log *.aux