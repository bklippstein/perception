
@ECHO OFF 
REM @cmd /C chcp 1252 > NUL
@cmd /C chcp 65001 > NUL
set RUBYOPT=-rubygems
echo.

cd test
ruby _start_all.rb

echo.
echo.
echo.
pause
