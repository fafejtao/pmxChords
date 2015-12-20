--[[
   (c) Copyright 2013 Ondrej Fafejta <fafejtao@gmail.com>
       https://github.com/fafejtao/pmxChords
]] --
--
-- Chords transposition class
--
ChordsTr = {} -- the table representing the class, which will double as the metatable for the instances
ChordsTr.__index = ChordsTr -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(ChordsTr,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end,
    })

--
-- global constants
--
ChordsTr.CHORDS_BEGIN = "\\ch."
ChordsTr.CHORDS_END = ".\\"
ChordsTr.BASE_CHORDS_ARR = {
    -- lua is indexing from 1 I need from 0 ...
    [0] = "C",
    [1] = "Cs",
    [2] = "D",
    [3] = "Ef",
    [4] = "E",
    [5] = "F",
    [6] = "Fs",
    [7] = "G",
    [8] = "Af",
    [9] = "A",
    [10] = "Bf",
    [11] = "B"
}

--
-- Create instance of chords transposition class
-- params iSig input signature  e.g. -1 - F major
--        oSig output signature e.g.  2 - D major
--
function ChordsTr.new(iSig, oSig)
    local self = setmetatable({}, ChordsTr)
    self.trMap = ChordsTr.__createTransposeMap(oSig - iSig)
    return self
end

--
-- Core of transposition.
-- Prepare map of transposed chords.
-- Key is input base chord and value is output base chord.
--
function ChordsTr.__createTransposeMap(sigDiff)
    local size = 12
    local halfTones = (sigDiff * 7) % size
    if (halfTones < 0) then
        halfTones = halfTones + size
    end

    -- generate transpose map of base chords ...
    local res = {}
    local i
    for i = 0, size - 1, 1 do
        local key = ChordsTr.BASE_CHORDS_ARR[i]
        local trIdx = (i + halfTones) % size;
        res[key] = ChordsTr.BASE_CHORDS_ARR[trIdx]
    end
    return res
end

--
-- transpose one line.
-- Find each chords in line and transpose it into output signature.
-- return transposed line.
--
function ChordsTr:lineTranspose(line)
    local pos = 0;
    local trLine = "" -- transposed line (result)
    while true do
        local i = line:find(ChordsTr.CHORDS_BEGIN, pos)
        if i == nil then
            trLine = trLine .. line:sub(pos)
            break
        end
        i = i + 3 -- move after \ch.
        trLine = trLine .. line:sub(pos, i) -- append non chord string into result
        pos = line:find(ChordsTr.CHORDS_END, i)
        if pos == nil then -- TODO check correctly end of chords ... e.g. check wrong line (first chord is not finished correctly): \ch.C. c \ch.G7.\ b
            io.stderr:write("End of chords was not found!\n")
            os.exit(-1)
        end
        local chord = line:sub(i + 1, pos - 1)
        trLine = trLine .. self:doTranspose(chord)
    end
    return trLine
end

--
-- do transpose of one chord.
--
function ChordsTr:doTranspose(chord)
    local base, alt = ChordsTr.splitChord(chord)
    return self.trMap[base] .. alt
end

--
-- Split chord into two part: base chord and chord alteration.
-- e.g. Fsm7 - base chord is Fs, alteration is m7
--
function ChordsTr.splitChord(chord)
    if (chord.len == 1) then
        return chord, ""
    end
    local secondChar = chord:sub(2, 2)
    if (secondChar == 's' or secondChar == 'f') then
        return chord:sub(1, 2), chord:sub(3)
    else
        return chord:sub(1, 1), chord:sub(2)
    end
end
--
-- end of ChordsTr class
--
