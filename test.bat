Set URL="https://www.ssl.com/download/codesigntool-for-windows/"
Set PATH="CodeSignTool-windows.zip"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Invoke-WebRequest -URI $URL -OutFile $PATH"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Expand-Archive -Force $PATH"
ls
cd CodeSignTool-windows
pwd
echo ---------------------------
.\CodeSignTool.bat --version
echo ---------------------------
echo %1
