echo %1
echo %test%
::%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Invoke-WebRequest -URI https://www.ssl.com/download/codesigntool-for-windows/ -OutFile CodeSignTool-windows.zip"
::%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Expand-Archive -Force CodeSignTool-windows.zip"
ls
::cd CodeSignTool-windows
echo ---------------------------
.\CodeSignTool-windows\CodeSignTool.bat --version
echo ---------------------------





