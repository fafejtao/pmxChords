#!/usr/bin/env texlua
--
-- global constants
--
VERSION = "0.9"
FILE_SUFFIX="_chtr"
PMX_CMD="pmxab"

--[[
   pmxchords.lua: transpose chords (\ch.C.\) and process pmxab

   (c) Copyright 2013 Ondrej Fafejta <fafejtao@gmail.com>
       https://github.com/fafejtao/pmxChords

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

--]]

--[[
  ChangeLog:

     version 0.9   2013-12-05 - rewrite code from perl to lua...
--]]

function usage()
  print("Usage:  [texlua] pmxchords.lua  basename[.pmx] ")
  print("     1. transpose chords into new file basename"..FILE_SUFFIX..".pmx")
  print("     2. call pmxab on transposed file basename"..FILE_SUFFIX..".pmx")
  print("     3. rename basename"..FILE_SUFFIX..".tex to basename.tex")
end

function whoami ()
  print("This is pmxchords.lua version ".. VERSION)
end

whoami()
if #arg == 0 then
  usage()
  os.exit(0)
end

require "ChordsTr" -- be careful file ChordsTr.lua must be on package.path

function parseInputSignature(line)
   -- parse input signature from pmx digits line. Only one line digits format is supported!
   -- e.g.
   --    1      1       2     4      2      4        0    -1
   -- signature is -1 : F major
   local res =  string.match(line, "^%s*[0-9]+%s+[0-9]+%s+[0-9]+%s+[0-9]+%s+[0-9]+%s+[0-9]+%s+[0-9]+%s+([%+%-]?[0-9]+)%s*$")
   return tonumber(res)
end

function parseOutputSignature(line)
   -- parse output signature from pmx 
   -- e.g.
   -- K-2+2
   -- output signature is +2 : D major
   local res =  string.match(line, "^K[%+%-]?[0-9]+([%+%-]?[0-9]+)")
   return tonumber(res)
end

function handleErr(msg) 
   io.stderr:write(msg.."\n")
   os.exit(2)
end

--
-- get file name without .pmx suffix
--
function getBaseFileName(fileName) 
   if fileName ~= "" and string.sub(fileName, -4, -1) == ".pmx" then
	  return string.sub(fileName, 1, -5)
   else
	  return fileName
   end
end

baseName = getBaseFileName(arg[1]) -- input file name without .pmx suffix

inputFileName = baseName..".pmx"
inputFile = io.open(inputFileName, "r")
if(inputFile == nil) then
   handleErr("File does not exist: "..inputFileName)
end

outputBaseName = baseName..FILE_SUFFIX   -- output base name without suffix. Used for renaming generated .tex file ...
outputFileName = outputBaseName..".pmx"
outputFile = io.open(outputFileName, "w")
if(outputFile == nil) then
   handleErr("Can not create temporary file: ".. outputFileName)
end

--
-- transpose chords from inputFile into outputFile
--
-- input and output signature will be parsed from input pmx file
-- 
iSig = nil  -- input signature
chTr = nil  -- chords transposition class

for line in inputFile:lines() do
   if(chTr ~= nil) then
	  outputFile:write(chTr:lineTranspose(line).."\n")
   else
	  outputFile:write(line.."\n")
   end
   if(iSig == nil) then
	  iSig = parseInputSignature(line)
	  if(iSig ~= nil) then
		 io.stderr:write("Chords: input signature detected: "..iSig .."\n")
	  end
   elseif(chTr == nil) then
	  local oSig = parseOutputSignature(line)
	  if(oSig ~= nil) then
		 io.stderr:write("Chords: output signature detected: "..oSig .."\n")
		 chTr = ChordsTr(iSig, oSig)
	  end
   end
end
inputFile:close()
outputFile:close()

--
-- call pmxab to generate .tex file
--
local pmxResCode = os.execute(PMX_CMD .. " " .. outputFileName )
if (pmxResCode ~= 0 ) then
   io.stderr:write("PMX process fail! "..outputFileName .."\n")
   os.exit(pmxResCode)
end

os.rename(outputBaseName..".tex", baseName..".tex")
os.remove(outputFileName) -- remove temporary file
