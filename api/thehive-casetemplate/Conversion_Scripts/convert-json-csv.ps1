$exportDir = "CaseTemplateExport"

$allTemplates = @()
$allTasks     = @()

# Loop through all JSON files
Get-ChildItem -Path $exportDir -Filter *.json | ForEach-Object {
    $json = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json

    # Template summary row
    $templateRow = [PSCustomObject]@{
        Id          = $json._id
        Name        = $json.name
        Severity    = $json.severity
        Tags        = ($json.tags -join ";")
        TaskCount   = ($json.tasks.Count)
        Description = $json.description
    }
    $allTemplates += $templateRow

    # Expand tasks into their own rows
    foreach ($task in $json.tasks) {
        $taskRow = [PSCustomObject]@{
            TemplateId   = $json._id
            TemplateName = $json.name
            TaskTitle    = $task.title
            TaskOrder    = $task.order
            TaskStatus   = $task.status
            TaskDesc     = $task.description
        }
        $allTasks += $taskRow
    }
}

# Export both collections to CSV
$allTemplates | Export-Csv -Path "Templates.csv" -NoTypeInformation -Encoding UTF8
$allTasks     | Export-Csv -Path "Tasks.csv"     -NoTypeInformation -Encoding UTF8
