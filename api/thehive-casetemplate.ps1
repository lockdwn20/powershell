# Define your API endpoint and key
$baseUrl = "https://your-hive-instance/api/v1"
$apiKey = "your_api_key_here"

# Set headers for authentication
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

# Query API body: request all case-template objects
$body = @{
    query = @{
        _name = "listCaseTemplates"
    }
} | ConvertTo-Json -Depth 10

#Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body '{"query":{"_name":"listCaseTemplates"}}' #test
$response = Invoke-RestMethod -Uri "$baseUrl/query" -Method POST -Headers $headers -Body $body

# Save each template
foreach ($doc in $response) {
    $template = $doc
    $name = $template.name -replace '[\\/:*?"<>|]', '_'
    $template | ConvertTo-Json -Depth 10 | Out-File -FilePath "$name.json" -Encoding utf8
}

$manifest = @()

foreach ($doc in $response) {
    $template = $doc #$doc._source to get the business fields
    $name = $template.name -replace '[\\/:*?"<>|]', '_'  # sanitize filename
    $filePath = Join-Path $exportDir "$name.json"

    # Save template JSON
    $template | ConvertTo-Json -Depth 10 | Out-File -FilePath $filePath -Encoding utf8

    # Add to manifest
    $manifest += $name
}

# Write manifest file
$manifest | Out-File -FilePath (Join-Path $exportDir "CaseTemplateManifest.txt") -Encoding utf8

# Create a ZIP archive of everything
$zipPath = "CaseTemplateExport.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath }
Compress-Archive -Path $exportDir\* -DestinationPath $zipPath


