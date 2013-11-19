czechFormat = false;
if(args.size() ==1 ) {
    if("1".equals(args[0])){
        czechFormat = true;
    }
}

preFile = new File("chords_pre.tex");

preFile.eachLine{println(it)}

variants = [
    ["", ""],
    ["m","m"],
    ["+","Plus"],
    ["4", "Sus"],
    ["dim","Dim"],
    ["maj","Maj"],
    ["6", "Six"],
    ["7", "Seven"],
    ["9", "Nine"],
    ["9f" ,"NineFlat"],
    ["m7","mSeven"],
    ["m6", "mSix"],
    ["m5f", "mFiveFlat"],
    ["47","SusSeven"],
    ["m75f","mSevenFiveFlat"]
];

// generate base chords without B
["C","D","E","F","G","A"].each{chord -> generateOneChord(chord, "", "", variants)}
// generate sharp chords C#, F#
["C","F"].each{chord -> generateOneChord(chord, "s", "Sharp", variants)}
// generate flat chords Ef, Af without Bf
["E","A"].each{chord -> generateOneChord(chord, "f", "Flat", variants)}

if(czechFormat){
    // B - czech as H
    generateOneChord("B", "","", variants, "H");
    // Bflat - czech as B
    generateOneChord("B", "f", "", variants, "B");
} else {
    // B - default as B
    generateOneChord("B", "", "", variants);
    // Bflat - default as Bf
    generateOneChord("B", "f", "Flat", variants);
}

void generateOneChord(chord, String chordPrefix, String macroPrefix, variants, specialChord = null){
    def finalChord= specialChord != null ? specialChord: chord
    println "\n%"
    println "% "+ chord + chordPrefix
    println "%"
    variants.each{v->
	println "\\defch.${chord}${chordPrefix}${v[0]}.{\\chX${macroPrefix}${v[1]}{${finalChord}}}";
    }
}
