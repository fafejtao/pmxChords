#!/usr/bin/env texlua

variants = {
    "",
    "m",
    "+",
    "4",
    "dim",
    "maj",
    "6",
    "7",
    "9",
    "9f",
    "m7",
    "m6",
    "m5f",
    "47",
    "m75f"
}

chords = { "C", "Cs", "D", "Ef", "E", "F", "Fs", "G", "Af", "A", "Bf", "B" }

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

function generateRef(czech)
    local res = readWholeFile("chords_ref_prefix.tex")

    local chordsMacro = "chords"
    local outputFileName = "chordsRef.tex"
    if czech then
        chordsMacro = "chordsCZ"
        outputFileName = "chordsRefCZ.tex"
    end
    res = res:gsub("&&&chordMacro&&&", chordsMacro)

    res = res .. "\n\\subsection*{Macro: " .. chordsMacro .. "}\n"
    res = res .. "\\begin{tabular}{ |"
    for i = 1, #chords do res = res .. " l |" end
    res = res .. "}\n"
    -- res = res .. "\\begin{tabular}{ | l | l | l | l | l | l | l | l | l | l | l | l |}";
    res = res .. "\\hline\n"

    for _, v in ipairs(variants) do
        for i = 1, 2 do
            for idx, chord in ipairs(chords) do

                local chStr
                if i == 1 then
                    chStr = "\\ch." .. chord .. v .. ".\n"
                else
                    chStr = "\\chSrc{" .. chord .. v .. "}\n"
                end

                if idx > 1 then
                    res = res .. "& " .. chStr
                else
                    res = res .. "  " .. chStr
                end
            end
            res = res .. "\\\\ \n"
        end
        res = res .. "\\hline\n"
    end

    res = res .. "\n\\end{tabular}\n\n"
    res = res .. "\\end{document}\n"
    print("Generating file: " .. outputFileName)
    writeContentToFile(outputFileName, res)
end

generateRef(true)
generateRef(false)