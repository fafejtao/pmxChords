#!/usr/bin/env texlua
--
-- it generates macros chords.tex and chordsCZ.tex.
--

variants = {
    { "", "" },
    { "m", "m" },
    { "+", "Plus" },
    { "4", "Sus" },
    { "dim", "Dim" },
    { "maj", "Maj" },
    { "6", "Six" },
    { "7", "Seven" },
    { "9", "Nine" },
    { "9f", "NineFlat" },
    { "m7", "mSeven" },
    { "m6", "mSix" },
    { "m5f", "mFiveFlat" },
    { "47", "SusSeven" },
    { "m75f", "mSevenFiveFlat" }
};

function generateOneChord(chord, chordPrefix, macroPrefix, specialChord)
    local res = "\n%" ..
            "\n% " .. chord .. chordPrefix ..
            "\n%\n"
    local finalChord
    if specialChord == nil then
        finalChord = chord
    else
        finalChord = specialChord
    end

    for _, v in ipairs(variants) do
        res = res .. "\\defch." .. chord .. chordPrefix .. v[1] .. ".{\\chX" .. macroPrefix .. v[2] .. "{" .. finalChord .. "}}\n"
    end
    return res
end

function generateMoreChords(chords, chordPrefix, macroPrefix)
    local res = ""
    for _, ch in ipairs(chords) do
        res = res .. generateOneChord(ch, chordPrefix, macroPrefix, nil)
    end
    return res
end

function readWholeFile(fileName)
    local f = io.open(fileName, "r")
    if (f == nil) then
        io.stderr:write("Can not open file: " .. fileName .. "\n")
        os.exit(2)
    end

    local content = f:read("*all")
    f:close()
    return content
end

function writeContentToFile(fileName, content)
    local f = io.open(fileName, "w")
    if (f == nil) then
        io.stderr:write("Can not open file for writing: " .. file .. "\n")
        os.exit(2)
    end
    f:write(content)
    f:close()
end

function generateMacro(czechFormat)
    -- copy content of chords_pre.tex to each macros
    local res = readWholeFile("chords_pre.tex")
    -- generate base chords without B
    res = res .. generateMoreChords({ "C", "D", "E", "F", "G", "A" }, "", "")

    -- generate sharp chords C#, F#
    res = res .. generateMoreChords({ "C", "F" }, "s", "Sharp")

    -- generate flat chords Ef, Af without Bf
    res = res .. generateMoreChords({ "E", "A" }, "f", "Flat")

    local outputFileName
    if czechFormat then
        outputFileName = "chordsCZ.tex"
        -- B - czech as H
        res = res .. generateOneChord("B", "", "", "H")
        -- Bflat - czech as B
        res = res .. generateOneChord("B", "f", "", "B")
    else
        outputFileName = "chords.tex"
        -- B - default as B
        res = res .. generateOneChord("B", "", "", nil)
        --  Bflat - default as Bf
        res = res .. generateOneChord("B", "f", "Flat", nil)
    end
    --    print(res)
    print("Generating file: " .. outputFileName)
    writeContentToFile(outputFileName, res)
end

generateMacro(true)
generateMacro(false)