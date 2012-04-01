#!/bin/sh

groovy generate_chords_macro.groovy > chords.tex
groovy generate_chords_macro.groovy 1 > chordsCZ.tex

cp chords.tex chordsCZ.tex ../../tex/
