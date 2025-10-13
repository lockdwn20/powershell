# Load template and JSON
$template = Get-Content "template.md" -Raw
$json = Get-Content "incident.json" | ConvertFrom-Json

# Replace simple fields
foreach ($key in $json.PSObject.Properties.Name) {
    $value = $json.$key
    if ($value -isnot [System.Collections.IEnumerable] -or $value -is [string]) {
        $template = $template -replace "{{\s*$key\s*}}", [regex]::Escape($value)
    }
}

# Replace tags loop
if ($template -match "{{#each tags}}(.*?){{/each}}") {
    $loopBlock = $matches[1]
    $tagOutput = ""
    foreach ($tag in $json.tags) {
        $tagOutput += ($loopBlock -replace "{{tags}}", [regex]::Escape($tag)) + "`n"
    }
    $template = $template -replace "{{#each tags}}.*?{{/each}}", [regex]::Escape($tagOutput)
}

# Replace tasks loop
if ($template -match "{{#each tasks}}(.*?){{/each}}") {
    $loopBlock = $matches[1]
    $taskOutput = ""
    foreach ($task in $json.tasks) {
        $block = $loopBlock
        foreach ($prop in $task.PSObject.Properties.Name) {
            $block = $block -replace "{{\s*$prop\s*}}", [regex]::Escape($task.$prop)
        }
        $taskOutput += "$block`n"
    }
    $template = $template -replace "{{#each tasks}}.*?{{/each}}", [regex]::Escape($taskOutput)
}

# Handle conditional block for extraData
if ($template -match "{{#if extraData}}(.*?){{/if}}") {
    if ($json.extraData) {
        $template = $template -replace "{{#if extraData}}.*?{{/if}}", [regex]::Escape($json.extraData)
    } else {
        $template = $template -replace "{{#if extraData}}.*?{{/if}}", "_No additional notes._"
    }
}

# Save final output
Set-Content "output.md" $template