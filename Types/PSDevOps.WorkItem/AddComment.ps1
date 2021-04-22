param($Comment)

$commentBody = 
    if ($Comment -is [string]) {
        @{text=$Comment}
    } else {
        $Comment
    }

Invoke-ADORestAPI -Uri "$($this.Url)/comments" -QueryParameter @{"api-version"="5.1-preview"} -Method POST -Body $commentBody -PSTypeName @(
    "$($this.Organization).$($this.Project).WorkItem.Comment"
    "$($this.Organization).WorkItem.Comment"
    "PSDevOps.WorkItem.Comment"
)