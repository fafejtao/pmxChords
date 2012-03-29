if(args.size() !=1 ) {
  println("File name parameter is required!");
  //println("Usage: "); //TODO
  System.exit(-1);
}

file = new File(args[0]);

def isigRegExp = /^ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *[0-9]+ *(\-{0,1}[0-9]+) *$/
def kRegExp = /^K[\+\-]{1}[0-9]{1}([\+\-]{1}[0-9]+) *$/

Integer isig = null;
ChordsTransposition chordsTransposition = null;
def matcher;

file.eachLine{
  if(isig == null) {
    matcher = ( it =~ isigRegExp );
    if (matcher.matches()) {
      isig = myToInt(matcher[0][1]);
    }
  } else if(isig != null && chordsTransposition == null) {
    matcher = ( it =~ kRegExp );
    if (matcher.matches()) {
      int ksig = myToInt(matcher[0][1]);
      chordsTransposition = new ChordsTransposition(isig, ksig)
    }
  }

  if ( chordsTransposition != null ) {
    println(chordsTransposition.transposeLine(it));
  } else {
    println (it);
  }
}

Integer myToInt(String s) {
  String tmp = s.startsWith("+") ? s.substring(1): s;
  return Integer.valueOf(tmp);
}

class ChordsTransposition {
  private chordsArr = ["C", "Cs", "D", "Ef", "E", "F", "Fs", "G", "Af", "A", "Bf", "B"];
  private chordsMap = [:];

  public static final def LINE_CHORDS_REG_EXP = ~"\\\\ch\\.([^\\.]*)\\.\\\\"


  ChordsTransposition(int isig, int ksig){
    int sigDiff = ksig - isig;
    int size = chordsArr.size();

    int halfTones = (sigDiff*7) % size;
    if(halfTones < 0) {
      halfTones = size + halfTones;
    }

    for (int i=0; i < size; i++){
      String x = chordsArr[i];
      int idx = (i+halfTones) % size;
      chordsMap[ x ] = chordsArr[idx];
    }
  }

  String transpose(String ch) {
    String res = chordsMap[ch];
    if(res == null) {
      throw new IllegalArgumentException("Unsupported chord: "+ch);
    }
    return res;
  }

  /**
   * Transpose full chords in format Em7 to correct chords.
   * For example if isig is 0 and ksig is +2 and input ch is 'Em7'
   * ( it means transpose from C-dur to D-dur) the result is Fsm7.
   */
  String transposeChord(String ch) {
    String baseChord = getBaseChord(ch);
    String transposedChord = transpose(baseChord);
    return ch.replace(baseChord, transposedChord);
  }

  private String getBaseChord(String ch){
    if(ch.size()>1){
      String secondChar = ch.charAt(1);
      if("s".equals(secondChar) || "f".equals(secondChar)){
        return ch.substring(0,2);
      }
    }
    return ch.substring(0,1);
  }

  public String transposeLine(String line){
    return line.replaceAll(LINE_CHORDS_REG_EXP, {"\\ch."+transposeChord(it[1])+".\\"});
  }
}
