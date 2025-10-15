try {
    $response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -TimeoutSec 30
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        Write-Host "Response body: $($reader.ReadToEnd())"
    }
}


$body = @{
    query = @(
        @{ _name = "listCase"; size = 1 }
    )
} | ConvertTo-Json -Depth 10

try {
    $test = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -TimeoutSec 15
    $test | ConvertTo-Json -Depth 5
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
