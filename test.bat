$URL="https://www.ssl.com/download/codesigntool-for-windows/"
$PATH="CodeSignTool-windows.zip"
Invoke-WebRequest -URI $URL -OutFile $PATH
Expand-Archive -Force $PATH
ls
cd CodeSignTool-windows
pwd
echo ---------------------------
.\CodeSignTool.bat --version
echo ---------------------------
echo %1
