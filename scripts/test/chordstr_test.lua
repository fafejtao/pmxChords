package.path = "../?.lua;"..package.path
require "ChordsTr"

function test(iSig, oSig, t) 
   local chTr = ChordsTr(iSig, oSig)
   for k,v in pairs(t) do
      local res = chTr:doTranspose(k)
      print(k, v, chTr:lineTranspose("Some text before chord, \\ch." .. k .. ".\\ bla bla"))
--      print(k, v, res)
      assert(v == res, "Illegal chord transposition! inputChord = "..k..", expected = "..v..", returned = ".. res)
   end
end

--
-- test F major -> D major
-- key is input chord
-- value is expected transposed chord
--
t={}
t["Cm7"] = "Am7"
t["Cs4"] = "Bf4"
t["Dm75b"] = "Bm75b"
t["Ef"] = "C"
t["E"] = "Cs"
t["F7"] = "D7"
t["Fs7"] = "Ef7"
t["G"] = "E"
t["Af"] = "F"
t["A7"] = "Fs7"
t["Bf"] = "G"
t["B6"] = "Af6"

test(-1, 2, t)


--
-- test half tone down e.g. F major -> E major
-- key is input chord
-- value is expected transposed chord
--
t={}
t["Cm7"] = "Bm7"
t["Cs4"] = "C4"
t["Dm75b"] = "Csm75b"
t["Ef"] = "D"
t["E"] = "Ef"
t["F7"] = "E7"
t["Fs7"] = "F7"
t["G"] = "Fs"
t["Af"] = "G"
t["A7"] = "Af7"
t["Bf"] = "A"
t["B6"] = "Bf6"

test(-1, 4, t)
