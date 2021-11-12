@echo on

REM Set some variables
set eMailTo=rljunggren@msn.com; rljunggren79@gmail.com
set eMailFrom=rljunggren@vertrax.com
set subj=-s "Test Email from Vertrax"
REM set body="C:\Users\JKing\Desktop\pingResults.txt"
set body=-body "Test msg from Vertrax..."
set server=-server F-BOX
REM set x=-x "X-Header-Test: Can Blat do it? Yes it Can!"
set debug=-debug -log blat.log -timestamp 

REM Run blat.
blat %body% -to %eMailTo% -f %eMailFrom% %subj% %server% %debug% %x%