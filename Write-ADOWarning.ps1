function Write-ADOWarning
{
    <#
    .Synopsis
        Writes an ADO Warning
    .Description
        Writes an Azure DevOps Warning
    .Example
        Write-ADOWarning "Stuff hit the fan"
    .Link
        Write-ADOError
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Directly outputs in certain scenarios")]
    param(
    # The Warning message.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Message,

    # An optional source path.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Source','FullName')]
    [string]
    $SourcePath,

    # An optional line number.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Line')]
    [uint32]
    $LineNumber,

    # An optional column number.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Column')]
    [uint32]
    $ColumnNumber,

    # An optional Warning code.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Code
    )

    begin {
        $cmdMd = [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
    }

    process {
        $properties = # Collect the optional properties
            @(foreach ($kv in $PSBoundParameters.GetEnumerator()) {
                if ($kv.Key -eq 'Message') { continue } # (anything but Message).
                if (-not $cmdMd.Parameters.ContainsKey($kv.Key)) { continue }
                "$($kv.Key.ToLower())=$($kv.Value)"
            }) -join ';'
        # Then output the Warning with it's message.
        $out = "##vso[task.logissue type=warning$(if ($properties){";$properties"})]$Message"

        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
    }
}
