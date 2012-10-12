
@ECHO OFF 
@cmd /C chcp 65001 > NUL
set RUBYOPT=-rubygems
echo.

rake publish

echo.
echo.
echo.
pause
