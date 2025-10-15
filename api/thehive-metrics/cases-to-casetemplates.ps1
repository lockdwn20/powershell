# --- Config ---
$baseUrl = "https://your-hive-instance/api/v1"
$apiKey  = "your_api_key_here"

$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

# --- Date range: from 1 Jan 2024 to now ---
$startDate = (Get-Date "2024-01-01T00:00:00Z").ToUniversalTime().ToString("o")
$endDate   = (Get-Date).ToUniversalTime().ToString("o")

# --- Pagination settings ---
$pageSize = 500
$from     = 0
$allCases = @()

do {
    $body = @{
        query = @(
            @{
                _name = "listCase"
                from  = $from
                size  = $pageSize
                range = @{
                    createdAt = @{
                        gte = $startDate
                        lte = $endDate
                    }
                }
            }
        )
    } | ConvertTo-Json -Depth 10

    $response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body

    if ($response) {
        $allCases += $response
        $from += $pageSize
    }

} while ($response.Count -eq $pageSize)

# --- Summarize by caseTemplate ---
$summary = $allCases |
    Group-Object -Property caseTemplate |
    Select-Object @{Name="CaseTemplate";Expression={$_.Name}}, @{Name="Count";Expression={$_.Count}}

# --- Export ---
$summary | ConvertTo-Json -Depth 5 | Out-File ".\CaseTemplateSummary.json" -Encoding UTF8
$summary | Export-Csv -Path ".\CaseTemplateSummary.csv" -NoTypeInformation -Encoding UTF8

# --- Display ---
$summary