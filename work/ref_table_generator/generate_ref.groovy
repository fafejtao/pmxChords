inputChords = "chords";
if(args.size() ==1 ) {
    if("1".equals(args[0])){
        inputChords = "chordsCZ";
    }
}

x = (new File("chords_ref_prefix.tex").text)
println x.replaceAll(~/&&&chordMacro&&&/, inputChords)

variants = [
    "", 
    "m",
    "+",
    "sus",
    "dim",
    "maj",
    "6",
    "7",
    "9",
    "9f" ,
    "m7",
    "m6",
    "m5f",
    "sus7",
    "m75f"
];

println "\\subsection*{Macro: ${inputChords}}"

chords = ["C", "Cs","D","Ef","E","F","Fs","G","Af","A","Bf","B"];
print "\\begin{tabular}{ |"
for (i in 1..chords.size()){ print (" l |")}
println "}";
// println "\\begin{tabular}{ | l | l | l | l | l | l | l | l | l | l | l | l |}";
println "\\hline";

variants.each{v ->
    for (i in 0..1){
        chords.eachWithIndex{ chord, idx->
            if(i == 0){
                chStr = "\\ch.${chord}${v}."
            } else {
                chStr = "\\chSrc{${chord}${v}}"
            }
            print (idx>0 ? "& " :"  ")
            println chStr;
        }
        println "\\\\ ";
    }
    println "\\hline";
}

println """
\\end{tabular}
""";

println "\\end{document}"