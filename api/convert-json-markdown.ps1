# Paths
$templatePath = "template.md"
$jsonFolder   = "C:\Path\To\JsonFiles"
$outputFolder = "C:\Path\To\Markdown"

# Load template once
$templateBase = Get-Content $templatePath -Raw

# Ensure output folder exists
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Process each JSON file
Get-ChildItem -Path $jsonFolder -Filter *.json | ForEach-Object {
    $jsonFile = $_.FullName
    $json     = Get-Content $jsonFile | ConvertFrom-Json
    $template = $templateBase

    # Replace simple fields (skip description, handle separately)
    foreach ($key in $json.PSObject.Properties.Name) {
        if ($key -eq 'description') { continue }
        $value = $json.$key
        if ($value -isnot [System.Collections.IEnumerable] -or $value -is [string]) {
            $pattern = "{{\s*$key\s*}}"
            $template = $template -replace $pattern, [string]$value
        }
    }

    # Incident description
    $template = $template -replace "{{\s*incidentDescription\s*}}", [string]$json.description

    # Tags loop
    if ($template -match "{{#each tags}}(?s)(.*?){{/each}}") {
        $loopBlock = $matches[1]
        $tagOutput = ($json.tags | ForEach-Object {
            $loopBlock -replace "{{\s*tags\s*}}", $_
        }) -join "`n"
        $template = $template -replace "{{#each tags}}(?s).*?{{/each}}", $tagOutput
    }

    # Replace tasks loop
    if ($template -match "{{#each tasks}}(?s)(.*?){{/each}}") {
        $loopBlock = $matches[1]

        # Sort tasks by the 'order' field (numeric sort)
        $sortedTasks = $json.tasks | Sort-Object {[int]$_.order}

        $taskOutput = foreach ($task in $sortedTasks) {
            $block = $loopBlock
            foreach ($prop in $task.PSObject.Properties.Name) {
                if ($prop -eq 'order') {
                    # Increment order by 1 before replacing
                    $block = $block -replace "{{\s*order\s*}}", ([int]$task.$prop + 1)
                } else {
                    $block = $block -replace "{{\s*$prop\s*}}", [string]$task.$prop
                }
            }
            $block
        }

        $template = $template -replace "{{#each tasks}}(?s).*?{{/each}}", ($taskOutput -join "`n")
    }

    # Conditional extraData
    if ($template -match "{{#if extraData}}(?s)(.*?){{/if}}") {
        if ($json.extraData) {
            $template = $template -replace "{{#if extraData}}(?s).*?{{/if}}", [string]$json.extraData
        } else {
            $template = $template -replace "{{#if extraData}}(?s).*?{{/if}}", "_No additional notes._"
        }
    }

    # Build output filename (replace spaces with underscores, change extension)
    $outName = ($_.BaseName -replace ' ', '_') + ".md"
    $outPath = Join-Path $outputFolder $outName

    # Save
    Set-Content -Path $outPath -Value $template -Encoding UTF8
    Write-Host "Converted $($_.Name) -> $outName"
}