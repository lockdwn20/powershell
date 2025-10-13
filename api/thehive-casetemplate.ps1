# Define your API endpoint and key
$baseUrl = "https://your-hive-instance/api"
$apiKey = "your_api_key_here"

# Set headers for authentication
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

# Get all case templates
$response = Invoke-RestMethod -Uri "$baseUrl/case-template" -Method GET -Headers $headers

# Save each template to a separate JSON file
foreach ($template in $response) {
    $id = $template.id
    $templateDetails = Invoke-RestMethod -Uri "$baseUrl/case-template/$id" -Method GET -Headers $headers
    $fileName = "$($templateDetails.name).json"
    $templateDetails | ConvertTo-Json -Depth 10 | Out-File -FilePath $fileName -Encoding utf8
}