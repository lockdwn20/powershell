$exportDir = "CaseTemplateExport"
$outputCsv = "TemplatesAndTasks.csv"

$allRows = @()

Get-ChildItem -Path $exportDir -Filter *.json | ForEach-Object {
    $json = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json

    # If no tasks, still emit one row so template isn't lost
    if ($null -eq $json.tasks -or $json.tasks.Count -eq 0) {
        $row = [PSCustomObject]@{
            TemplateId   = $json._id
            TemplateName = $json.name
            Severity     = $json.severity
            Tags         = ($json.tags -join ";")
            Description  = $json.description
            TaskTitle    = ""
            TaskOrder    = ""
            TaskStatus   = ""
            TaskDesc     = ""
        }
        $allRows += $row
    }
    else {
        foreach ($task in $json.tasks) {
            $row = [PSCustomObject]@{
                TemplateId   = $json._id
                TemplateName = $json.name
                Severity     = $json.severity
                Tags         = ($json.tags -join ";")
                Description  = $json.description
                TaskTitle    = $task.title
                TaskOrder    = $task.order
                TaskStatus   = $task.status
                TaskDesc     = $task.description
            }
            $allRows += $row
        }
    }
}

$allRows | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8
