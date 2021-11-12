@ECHO OFF 
REM --------------------------------
REM Specify output file, date and time.
REM --------------------------------
SET statusfile=c:\vertrax\status.txt
DEL %statusfile%
ECHO %DATE% %TIME% > %statusfiles%

REM --------------------------------
REM Specify input file of server names.
REM --------------------------------
SET serverfile=c:\vertrax\testServers.txt

REM --------------------------------
REM Specify list of Windows services.
REM --------------------------------
SET srvc1="Pervasive.SQL (transactional)"
SET srvc2="Pervasive.SQL (relational)"
SET srvc3="domain1Service"
SET srvc4="niakwa"
SET srvc5="spooler"
REM SET srvc4="msiserver", "defragsvc"

REM --------------------------------
REM Iterate through servers.
REM --------------------------------
ECHO ---------- >> %statusfile%
ECHO ----------  Inspecting FuelPak servers           ----------- >> %statusfile%
ECHO ---------- >> %statusfile%
for /f "tokens=*" %%a in (%serverfile%) do call :servicecheck %%a

REM --------------------------------
REM Next, check Terminal Servers for 3 Orgs (DIV, OCO, LAKES).
REM --------------------------------
ECHO ---------- >> %statusfile%
ECHO ----------  Inspecting dedicated Terminal Servers ----------- >> %statusfile%
ECHO ---------- >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrddiv01 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDDIV01: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrddiv02 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDDIV01: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxentoco01 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXENTOCO01: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxentoco02 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXENTOCO02: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrdlakes01 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDLAKES01: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrdlakes02 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDLAKES02: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrdlakes03 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDLAKES03: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxrdlakes04 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXRDLAKES04: %srvc5% is %%i >> %statusfile%

REM --------------------------------
REM Finally, check individual other purpose servers.
REM --------------------------------
ECHO ---------- >> %statusfile%
ECHO ----------  Inspecting individual servers ----------- >> %statusfile%
ECHO ---------- >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxwebpay01 query %srvc5%^|FIND "STATE"') DO ECHO Inspecting VTXWEBPAY01: %srvc5% is %%i >> %statusfile%
FOR /f "tokens=4" %%i IN ('sc \\vtxwebpay01 query Tomcat7^|FIND "STATE"') DO ECHO Inspecting VTXWEBPAY01: Tomcat7 is %%i >> %statusfile%

goto :EOF

REM --------------------------------
REM Iterate through Windows services.
REM --------------------------------
:servicecheck
ECHO/|set /p= Inspecting %1: >> %statusfile%

REM Run Diagnostic on services.
SET ALARM=false
FOR /f "tokens=4" %%i IN ('sc \\%1 query %srvc1%^|FIND "STATE"') DO (
	IF %%i NEQ RUNNING (
		SET ALARM=true
		ECHO %srvc1% IS %%i >> %statusfile%
	)
)
FOR /f "tokens=4" %%i IN ('sc \\%1 query %srvc2%^|FIND "STATE"') DO (
	IF %%i NEQ RUNNING (
		SET ALARM=true
		ECHO %srvc2% IS %%i  >> %statusfile%
	)
)
FOR /f "tokens=4" %%i IN ('sc \\%1 query %srvc3%^|FIND "STATE"') DO (
	IF %%i NEQ RUNNING (
		SET ALARM=true
		ECHO %srvc3% IS %%i >> %statusfile%
	)
)
FOR /f "tokens=4" %%i IN ('sc \\%1 query %srvc4%^|FIND "STATE"') DO (
	IF %%i NEQ RUNNING (
		SET ALARM=true
		ECHO %srvc4% IS %%i >> %statusfile%
	)
)
FOR /f "tokens=4" %%i IN ('sc \\%1 query %srvc5%^|FIND "STATE"') DO (
	IF %%i NEQ RUNNING (
		SET ALARM=true
		ECHO %srvc5% IS %%i >> %statusfile%
	)
)

IF %ALARM%==false (
	ECHO All Windows services running. >> %statusfile%
)

:EOF
