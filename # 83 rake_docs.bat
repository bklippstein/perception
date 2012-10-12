
@ECHO OFF 
@cmd /C chcp 65001 > NUL
set RUBYOPT=-rubygems
echo.

rake docs

echo.
echo.
echo.
pause
