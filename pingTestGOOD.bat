@echo off
setlocal enabledelayedexpansion

REM ----- 1 ------------
REM Prepare files.
set OUTPUT_FILE=pingResults.txt
>nul copy nul %OUTPUT_FILE%
REM echo Time is %TIME%... >>%OUTPUT_FILE%

REM ----- 2 ------------
REM Calculate time to determine positive or negative test.

REM Get start time:
set sixam=06:00:00.00
for /F "tokens=1-4 delims=:.," %%a in ("%sixam%") do (
   set /A "sixam_centi=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
REM echo 6:00am string to centi: %sixam_centi%

REM Get current time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "now_time_centi=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
REM echo Now string to centi:    %now_time_centi%

REM Get elapsed time:
set /A elapsed=now_time_centi-sixam_centi

REM echo Elapsed time:           %elapsed%

REM If less than 5 minutes, send out an affirmative email.
set daily=false
if %elapsed% LEQ 30000 if %elapsed% GEQ 0 (set daily=true) else (set daily=false)
REM echo %daily%

REM ----- 3 ------------
REM Now perform PING tests.
for /f %%i in (testservers.txt) do (
    set SERVER_ADDRESS=ADDRESS N/A
    for /f "tokens=1,2,3" %%x in ('ping -n 3 %%i ^&^& echo SERVER_IS_UP') do (
		if %%x==Pinging set SERVER_ADDRESS=%%y
		if %%x==Reply set SERVER_ADDRESS=%%z
        if %%x==SERVER_IS_UP (set SERVER_STATE=UP) else (set SERVER_STATE=DOWN)
	)
	if %daily%==true (echo %%i [!SERVER_ADDRESS::=!] is !SERVER_STATE! >>%OUTPUT_FILE%)
	if %daily%==false if !SERVER_STATE!==DOWN (echo %%i [!SERVER_ADDRESS::=!] is !SERVER_STATE! >>%OUTPUT_FILE%)
)

REM ----- 4 ------------
REM Now perform Web Service URL tests.
for /f %%i in (testWebServices.txt) do (
	cscript /nologo URL\wget.js %%i %daily% >> %OUTPUT_FILE%
)

REM ----- 5 ------------
REM Now perform RPC (RDP Service port 3389) tests.


REM ----- 6 ------------
REM Email results if resulting file is not empty.

REM Test whether ping results file is empty.
for %%A in (%OUTPUT_FILE%) do set fileSize=%%~zA

REM Set some variables rljunggren@vertrax.com
set toMail=datacentersupport@vertrax.com
set fromMail=it@vertrax.com
set subj=-s "Ping Results - origin Cloud Smart Network"
set body=%OUTPUT_FILE%
REM set body=-body "test msg..."
set server=-server F-BOX
REM set x=-x "X-Header-Test: Can Blat do it? Yes it Can!"
REM set debug=-debug -log blat.log -timestamp 

REM Run blat.
if %fileSize% NEQ 0 (Blat\blat %body% -to %toMail% -f %fromMail% %subj% %server% %debug% %x%)
