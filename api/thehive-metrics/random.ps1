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

$body = @{
    query = @(
        @{
            _name = "listCase"
            size  = 1
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Request body:" -ForegroundColor Yellow
Write-Host $body

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -TimeoutSec 15
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 5
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        Write-Host "Response body: $($reader.ReadToEnd())"
    }
}

$baseUrl = "https://your-hive-instance/api/v1"
$apiKey  = "your_api_key_here"

$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

$body = @{
    query = @(
        @{
            _name   = "listCase"
            size    = 1
            _fields = @("id")
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Sending body:" $body

$response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body
$response

-----------

# --- Config ---
$baseUrl = "https://your-hive-instance/api/v1"
$apiKey  = "your_api_key_here"

$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

# --- Narrow date range: just one day ---
$startDate = "2024-10-01T00:00:00Z"
$endDate   = "2024-10-02T00:00:00Z"

# --- Build body with explicit fields and small page ---
$body = @{
    query = @(
        @{
            _name   = "listCase"
            from    = 0
            size    = 1
            range   = @{
                createdAt = @{
                    gte = $startDate
                    lte = $endDate
                }
            }
            _fields = @("id","title","caseTemplate","createdAt")
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Sending body:" $body -ForegroundColor Yellow

# --- Use Invoke-WebRequest to see raw response ---
try {
    $raw = Invoke-WebRequest -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "HTTP Status:" $raw.StatusCode -ForegroundColor Green
    Write-Host "First 200 chars of response:" -ForegroundColor Cyan
    $raw.Content.Substring(0, [Math]::Min(200, $raw.Content.Length))
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

$body = @{
    query = @(
        @{
            _name   = "listCaseTemplate"
            from    = 0
            size    = 5
            _fields = @("id","name")
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Sending body:" $body -ForegroundColor Yellow

try {
    $raw = Invoke-WebRequest -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "HTTP Status:" $raw.StatusCode -ForegroundColor Green
    Write-Host "First 300 chars of response:" -ForegroundColor Cyan
    $raw.Content.Substring(0, [Math]::Min(300, $raw.Content.Length))
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

$body = @{
    query = @(
        @{
            _name   = "listCase"
            from    = 0
            size    = 1
            range   = @{
                createdAt = @{
                    gte = "2024-10-01T00:00:00Z"
                    lte = "2024-10-02T00:00:00Z"
                }
            }
            _fields = @("id","title","caseTemplate","createdAt")
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Sending body:" $body -ForegroundColor Yellow

$raw = Invoke-WebRequest -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body -ContentType "application/json"
Write-Host "HTTP Status:" $raw.StatusCode -ForegroundColor Green
$raw.Content.Substring(0, [Math]::Min(300, $raw.Content.Length))