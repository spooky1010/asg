%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Invoke-WebRequest -URI https://www.ssl.com/download/codesigntool-for-windows/ -OutFile CodeSignTool-windows.zip"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Expand-Archive -Force $PATH"
ls
cd CodeSignTool-windows
echo ---------------------------
.\CodeSignTool.bat --version
echo ---------------------------
echo %1
