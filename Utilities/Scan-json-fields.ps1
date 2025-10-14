param (
    [string]$RootPath = ".",
    [string[]]$Fields = @("title", "tags", "status")
)

Get-ChildItem -Path $RootPath -Recurse -Filter *.json -File | ForEach-Object {
    try {
        $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
        $output = [ordered]@{
            File = $_.Name
        }

        foreach ($field in $Fields) {
            $value = $json.PSObject.Properties[$field]?.Value
            $output[$field] = if ($null -ne $value) { $value } else { "[missing]" }
        }

        [PSCustomObject]$output
    } catch {
        Write-Warning "Failed to parse JSON: $($_.FullName)"
    }
}