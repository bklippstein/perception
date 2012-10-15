
@ECHO OFF 
@cmd /C chcp 65001 > NUL
set RUBYOPT=-rubygems
echo.

rake redocs

echo.
echo.
echo.
pause
