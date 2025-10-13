# Define your API endpoint and key
$baseUrl = "https://your-hive-instance/api/v1"
$apiKey = "your_api_key_here"

# Set headers for authentication
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

# Empty query returns all case templates
$body = @{ query = @{} } | ConvertTo-Json -Depth 10

$response = Invoke-RestMethod -Uri "$baseUrl/db/case-template/_search" -Method POST -Headers $headers -Body $body

# Create export folder
$exportDir = "CaseTemplateExport"
if (-not (Test-Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir | Out-Null
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


