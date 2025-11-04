###Usage Convert-JsonToCsv -JsonPath "<name or *>.json" -CsvPath "customFields.csv"


function Convert-JsonToCsv {
    param(
        [Parameter(Mandatory)]
        [string]$JsonPath,   # can be a file, folder, or wildcard like *.json

        [Parameter(Mandatory)]
        [string]$CsvPath
    )

    # Resolve all matching files
    $files = Get-ChildItem -Path $JsonPath -File

    $all = foreach ($file in $files) {
        $json = Get-Content -Raw $file.FullName | ConvertFrom-Json

        foreach ($obj in $json) {
            $props = @{}
            foreach ($p in $obj.PSObject.Properties) {
                if ($p.Value -is [System.Collections.IEnumerable] -and -not ($p.Value -is [string])) {
                    $props[$p.Name] = ($p.Value -join "; ")
                }
                elseif ($p.Value -is [PSCustomObject]) {
                    $props[$p.Name] = ($p.Value.PSObject.Properties |
                        ForEach-Object { "$($_.Name)=$($_.Value)" }) -join "; "
                }
                else {
                    $props[$p.Name] = $p.Value
                }
            }
            # Add source filename for traceability
            $props["SourceFile"] = $file.Name
            [PSCustomObject]$props
        }
    }

    $all | Export-Csv -Path $CsvPath -NoTypeInformation
}
    }

    # Export to CSV
    $flattened | Export-Csv -Path $CsvPath -NoTypeInformation
}
