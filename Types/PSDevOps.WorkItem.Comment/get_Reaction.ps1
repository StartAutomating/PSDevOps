Invoke-ADORestAPI -Uri "$($this.Url)/reactions" -Property @{
    Project = $this.Project
    Organization = $this.Organization
    WorkItemID = $this.WorkItemID
    Comment = $this.Comment
} -PSTypeName @(
    "$($this.Organization).$($this.Project).WorkItem.CommentReaction"
    "$($this.Organization)..WorkItem.CommentReaction"
    'PSDevOps.WorkItem.CommentReaction'
)
