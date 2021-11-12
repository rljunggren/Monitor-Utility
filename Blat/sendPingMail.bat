@echo on

set OUTPUT_FILE="C:\vertrax\MonitorUtility\pingResults.txt"

REM Set some variables
set eMail=rljunggren@vertrax.com
set subj=-s "Test Blat"
set body=%OUTPUT_FILE%
REM set body=-body "test msg..."
set server=-server F-BOX
REM set x=-x "X-Header-Test: Can Blat do it? Yes it Can!"
REM set debug=-debug -log blat.log -timestamp 

REM Test whether ping results file is empty.
for %%A in (%OUTPUT_FILE%) do set fileSize=%%~zA

REM Run blat.
if %fileSize% NEQ 0 (blat %body% -to %eMail% -f %eMail% %subj% %server% %debug% %x%)

pause