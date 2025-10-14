param (
    [string]$RootPath = ".",
    [string]$FieldName = "targetField"
)

Get-ChildItem -Path $RootPath -Recurse -Filter *.json -File | ForEach-Object {
    try {
        $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
        if ($json.PSObject.Properties[$FieldName]) {
            $value = $json.$FieldName
            [PSCustomObject]@{
                File      = $_.FullName
                Field     = $FieldName
                Value     = $value
            }
        }
    } catch {
        Write-Warning "Failed to parse JSON: $($_.FullName)"
    }
}