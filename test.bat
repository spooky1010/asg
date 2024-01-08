Set URL="https://www.ssl.com/download/codesigntool-for-windows/"
Set PATH="CodeSignTool-windows.zip"
powershell -Command "Invoke-WebRequest -URI $URL -OutFile $PATH"
powershell -Command "Expand-Archive -Force $PATH"
ls
cd CodeSignTool-windows
pwd
echo ---------------------------
.\CodeSignTool.bat --version
echo ---------------------------
echo %1
