function Get-ADOTask
{
    <#
    .Synopsis
        Gets Azure DevOps Tasks
    .Description
        Gets Tasks and Task Groups from Azure DevOps
    .Example
        Get-ADOTask -Organization StartAutomating
    .Link
        Convert-ADOPipeline
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/distributedTask/Tasks')]
    [OutputType('PSDevOps.Task')]
    param(
    # The organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project.  Required to get task groups.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{Project}/_apis/distributedTask/taskGroups/')]
    [string]
    $Project,

    # If set, will get task groups related to a project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{Project}/_apis/distributedTask/taskGroups/')]
    [Alias('TaskGroups')]
    [switch]
    $TaskGroup,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                (. $ReplaceRouteParameter $psCmdlet.ParameterSetName)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'

        # We want to decorate our return value.  Handily enough, both URIs contain a distinct name in the last URL segment.
        $typename = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') # We just need to drop the 's'
        $typeNames = @(
            "$organization.$typename"
            if ($Project) { "$organization.$Project.$typename" }
            "PSDevOps.$typename"
        )

        $invokeResult = Invoke-ADORestAPI -Uri $uri @invokeParams
        if ($invokeResult -is [string]) { # The /tasks endpoint returns malformed JSON.
            $invokeResult = ($invokeResult -replace '""', '"_blank"') | # we have to fix it, by replacing blank strings with "_blank"
                Microsoft.PowerShell.Utility\ConvertFrom-Json | # then we use the built-in ConvertFrom-JSON
                Select-Object -ExpandProperty Value # and expand out the .Value property.
            $invokeResult = foreach ($ir in $invokeResult) {
                $ir.pstypenames.clear()
                foreach ($tn in $typeNames) {
                    $ir.pstypenames.Add($tn)
                }
                $ir
            }
        }

        $invokeResult | # Now that we've fixed the result
            Add-Member NoteProperty Organization $Organization -Force -PassThru | # add on the .Organization property
            Add-Member NoteProperty Server $Server -Force -PassThru # and the .Server property.
    }
}
