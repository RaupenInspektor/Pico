Set WshShell = CreateObject("WScript.Shell" ) 
WshShell.Run chr(34) & "C:\Users\vikto\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\receiver.bat" & Chr(34), 0 
Set WshShell = Nothing