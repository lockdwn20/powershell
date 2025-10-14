# Load template and JSON
$template = Get-Content "template.md" -Raw
$json = Get-Content "incident.json" | ConvertFrom-Json

# Replace simple fields
foreach ($key in $json.PSObject.Properties.Name) {
    $value = $json.$key
    if ($value -isnot [System.Collections.IEnumerable] -or $value -is [string]) {
        $pattern = "{{\s*$key\s*}}"
        $template = $template -replace $pattern, [string]$value
    }
}

# Replace tags loop
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
    $taskOutput = foreach ($task in $json.tasks) {
        $block = $loopBlock
        foreach ($prop in $task.PSObject.Properties.Name) {
            $block = $block -replace "{{\s*$prop\s*}}", [string]$task.$prop
        }
        $block
    }
    $template = $template -replace "{{#each tasks}}(?s).*?{{/each}}", ($taskOutput -join "`n")
}

# Handle conditional block for extraData
if ($template -match "{{#if extraData}}(?s)(.*?){{/if}}") {
    if ($json.extraData) {
        $template = $template -replace "{{#if extraData}}(?s).*?{{/if}}", [string]$json.extraData
    } else {
        $template = $template -replace "{{#if extraData}}(?s).*?{{/if}}", "_No additional notes._"
    }
}

# Save final output
Set-Content "output.md" $template -Encoding UTF8