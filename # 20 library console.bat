
@ECHO OFF 
REM @cmd /C chcp 1252 > NUL
@cmd /C chcp 65001 > NUL
set RUBYOPT=-rubygems
echo.

cd script
ruby console.rb

echo.
echo.
echo.
pause
