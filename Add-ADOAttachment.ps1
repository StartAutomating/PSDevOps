function Add-ADOAttachment
{
    <#
    .Synopsis
        Adds an ADO Attachment
    .Description
        Adds an Azure DevOps Attachment
    .Example
        Add-ADOAttachment -Path .\a.zip
    .Example
        Add-ADOAttachment -Path .\summary.md -IsSummary
    .Example
        Add-ADOAttachment -Path .\log.txt -IsLog
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [CmdletBinding(DefaultParameterSetName='task.uploadfile')]
    param(
    [Parameter(Mandatory,ParameterSetName='task.uploadfile',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='task.addattachment',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='task.uploadsummary',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='task.uploadlog',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='artifact.upload',ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $Path,

    # The Attachment name.  This is used to upload information for an Azure DevOps extension.
    [Parameter(Mandatory,Position=0,ParameterSetName='task.addattachment',ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The Attachment type.  This is used to upload information for an Azure DevOps extension.
    [Parameter(Mandatory,Position=1,ParameterSetName='task.addattachment',ValueFromPipelineByPropertyName)]
    [string]
    $Type,

    # The Container Folder.  This is required when uploading artifacts.
    [Parameter(Mandatory,ParameterSetName='artifact.upload',ValueFromPipelineByPropertyName)]
    [string]
    $ContainerFolder,

    # The Artifact Name.
    [Parameter(Mandatory,ParameterSetName='artifact.upload',ValueFromPipelineByPropertyName)]
    [string]
    $ArtifactName,
    
    # If set, the upload will be treated as a summary.  Summary uploads must be markdown.
    [Parameter(Mandatory,ParameterSetName='task.uploadsummary',ValueFromPipelineByPropertyName)]
    [Alias('Summary')]
    [switch]
    $IsSummary,
    
    # If set, the upload will be treated as a log file.
    [Parameter(Mandatory,ParameterSetName='task.uploadlog',ValueFromPipelineByPropertyName)]
    [Alias('Log')]
    [switch]
    $IsLog)

    begin {
        $cmdMd = [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
    }

    process {
        if ($DebugPreference -eq 'SilentlyContinue') {
            $rp = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path)
            if (-not $rp) { return }
        } else {
            $rp = $Path
        }
         
        $properties = # Collect the optional properties
            @(foreach ($kv in $PSBoundParameters.GetEnumerator()) {
                if ($kv.Key -eq 'Path') { continue } # (anything parameter but Path
                if ($kv.Value -is [switch]) {continue } # that is not a switch parameter).
                if (-not $cmdMd.Parameters.ContainsKey($kv.Key)) { continue }
                "$($kv.Key.ToLower())=$($kv.Value)"
            }) -join ';'
                
        $out = "##vso[$($pscmdlet.ParameterSetName)$(if ($properties) {" $properties"})]$rp"
        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
    }
}