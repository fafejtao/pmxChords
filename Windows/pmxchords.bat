:: wrapper script to call pmxchords.lua
:: Usage: pmxchords [options] basename[.pmx]
:: Suggested by Tomasz Luczak (Tomek) t34www@googlemail.com

@for /f "delims=" %%I in ('kpsewhich --format=texmfscripts %~n0.lua') do texlua "%%I" %*
:end
