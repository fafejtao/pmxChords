#!/usr/bin/env texlua
--
-- global constants
--
VERSION = "0.9"
TEX_CMD="etex"
PDFTEX_CMD="pdfetex"

--[[
   musixtex_steps.lua: Makes three pass musixtex steps. e.g. tex / musixflx / tex

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

     version 0.9   2013-12-09 - rewrite code from perl to lua...
--]]

function usage()
  print("Usage:  [texlua] musixtex_steps.lua  basename[.tex] ")
  print("Make three musixtex steps.")
  print("   1. call tex basename")
  print("   2. call musixflx basename")
  print("   3. call again tex basename")
  print("options: -v  version")
  print("         -h  help")
  print("         -d  dvi output. Use etex. Default is used pdftex (e.g. pdf output)")
end

function whoami ()
  print("This is musixtex_steps.lua version ".. VERSION)
end

whoami()
if #arg == 0 then
  usage()
  os.exit(0)
end

-- default use pdftex
tex = PDFTEX_CMD
musixflx = "musixflx"

--
-- get file name without .tex suffix
--
function getBaseFileName(fileName) 
   if fileName ~= "" and string.sub(fileName, -4, -1) == ".tex" then
	  return string.sub(fileName, 1, -5)
   else
	  return fileName
   end
end

function clearFiles(baseName)
   os.remove( "pmxaerr.dat" )
   os.remove( baseName .. ".mx1" )
   os.remove( baseName .. ".mx2" )
end

exit_code = 0
narg = 1
repeat
   this_arg = arg[narg]

   if this_arg == "-v" then
      os.exit(0)
   elseif this_arg == "-h" then
      usage()
      os.exit(0)
   elseif this_arg == "-d" then
      tex = TEX_CMD
   else
      baseFileName = getBaseFileName(this_arg)
      clearFiles(baseFileName)

      if(os.execute(tex .. " " .. baseFileName ) == 0 and
	 os.execute(musixflx .. " " .. baseFileName ) == 0 and
	 os.execute(tex .. " " .. baseFileName ) == 0) then
	 clearFiles(baseFileName)
	 print ("Musix tex steps passed!")
      else
	 exit_code = 2
      end
   end
  narg = narg + 1
until narg > #arg 

os.exit( exit_code )
