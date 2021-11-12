@echo off

set OUTPUT_FILE=urlResults.txt
>nul copy nul %OUTPUT_FILE%

set daily=true

for /f %%i in (testWebServices.txt) do (

	cscript /nologo wget.js %%i %daily% >> "urlResults.txt"
	REM cscript /nologo wget.js "blount.vertrax.com:8080" "http://blount.vertrax.com:8080/fp/rs/system/testConn?server=VTXENTBLO01&port=1583&db=ENTBLOBR001" > "output.txt"
	REM echo %%i
)

REM pause
