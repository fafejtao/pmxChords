#!/usr/bin/perl

#
# Author: Ondrej Fafejta
# Date: 2012-02-20 
#

while ($line = <STDIN>) {
   chomp;
   if(!defined $iSig) {
       # obtain input signature
       if($line =~ m/^ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *(\-{0,1}[0-9]+) *$/){
	   $iSig = int($1);
#       print "% TEST: Signature matches: input signature == ".$iSig."\n";
       }
   }
   if(defined $iSig && !defined $kSig) {
       # if input signature is defined find destination signature. e.g. keyword: K-2+2
       if($line =~ m/^K[\+\-]{1}[0-9]{1}([\+\-]{1}[0-9]+) *$/){
	   $kSig=int($1);
#	   print "% TEST: Ksig matches: destination signature == ".$kSig."\n";
	   if($kSig != $iSig){
	       # create chords transposeMap - global variable! (only if input signature is not equal to destination signature)
	       %transposeMap = createTransposeMap($kSig - $iSig);
	   }
       }
   }
   if (%transposeMap){
       # make transposition
       $line =~ s/\\ch\.([^\.]*)\.\\/"\\ch\.".transpose($1)."\.\\"/eg;
   }
   print $line;
}

#
# Function transposes whole chord to destination signature.
# Function requires global map of transposed chords %transposeMap.
# -- see function createTransposeMap ...
#
sub transpose {
    ($chord) = @_;
    ($baseChord, $chordAlt) = parseChord($chord);
    $transposedBaseChord = $transposeMap{$baseChord};
    if (!defined $transposedBaseChord) {
	die "Error: Unsupported chord: baseChord == $baseChord. Whole chord = $chord.";
    }
    return $transposedBaseChord.$chordAlt;
}

#
# Create transpose map.
# It is the core method of whole transposition.
# It prepares the map of chords.
# - key in the map is input base chords
# - value in the map is transposed destination chord.
#
sub createTransposeMap {
    ($sigDiff) = @_;
    @chordsArr = ("C", "Cs", "D", "Ef", "E", "F", "Fs", "G", "Af", "A", "Bf", "B");
    $size = @chordsArr; # size is 12

    $halfTones = ($sigDiff*7) % $size;
    if($halfTones < 0) {
	$halfTones = $size + $halfTones;
    }
    
    %res=();
    for ($i = 0; $i< $size; $i++){
	$key = $chordsArr[$i];
	$idx = ($i + $halfTones) % $size;
	$res{$key} = $chordsArr[$idx];
    }
    return %res;
}

#
# Split one chord into base chord and chord alteration.
# E.g. for chord Csm75f return Cs as base chord and m75f as chord alteration.
# return array 
#  - first item baseChord Cs
#  - second item chord alteration m75f
#
# I believe it can be achieved more simply...
sub parseChord {
    ($chord) = @_;
    my $len = length($chord);
    if($len >1 ) {
	$secondChar = substr($chord, 1, 1);
	if($secondChar =~ m/s|f/){ # second character is sharp or flat symbol
	    $altIdx = 2;
	} else {
	    $altIdx = 1;
	}
	$baseChord = substr($chord, 0, $altIdx);
	$chordAlt = substr($chord, $altIdx);
    } else {
	$baseChord = $chord;
	$chordAlt = "";
    }
    @res = ($baseChord, $chordAlt);
    return @res;
}
