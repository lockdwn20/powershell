$body = @{
    query = @(
        @{
            _name   = "listCase"
            _fields = @("id","title","status","createdAt","caseTemplate")
        }
        @{
            _name = "page"
            from  = 0
            to    = 5
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

$response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body
$response

$body = @{
    query = @(
        @{ _name = "listCase" }
        @{ _name = "page"; from = 0; to = 5 }
        @{
            _name   = "project"
            _fields = @("id","title","status","createdAt","caseTemplate")
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

$response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body
$response