param (
    [string]$RootPath = ".",
    [string[]]$Fields = @("title", "tags", "status")
    [string]$CsvExport = ".\export.csv"
)

Get-ChildItem -Path $RootPath -Recurse -Filter *.json -File | ForEach-Object {
    try {
        # Parse JSON file
        $json = Get-Content $_.FullName -Raw | ConvertFrom-Json

        # Start building output row
        $output = [ordered]@{
            File = $_.BaseName   # filename without extension
        }

        # Loop through requested fields
        foreach ($field in $Fields) {
            if ($json.PSObject.Properties[$field]) {
                $output[$field] = $json.$field
            }
            else {
                $output[$field] = "[missing]"
            }
        }

        # Emit as object
        [PSCustomObject]$output
    }
    catch {
        Write-Warning "Failed to parse JSON: $($_.FullName)"
    }
} | Export-Csv "$CsvExport" -NoTypeInformation