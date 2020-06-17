function Get-ADOTask
{
    <#
    .Synopsis
        Gets Azure DevOps Tasks
    .Description
        Gets Tasks and Task Groups from Azure DevOps
    .Example
        Get-ADOTask -Organization StartAutomating
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/distributedTask/Tasks')]
    param(
    # The organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project.  Required to get task groups.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Organization}/{Project}/_apis/distributedTask/taskGroups/')]
    [string]
    $Project,

    # If set, will get task groups related to a project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Organization}/{Project}/_apis/distributedTask/taskGroups/')]
    [Alias('TaskGroups')]
    [switch]
    $TaskGroup,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $psParameterSet = $psCmdlet.ParameterSetName


        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                (. $ReplaceRouteParameter $psParameterSet)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'

        $uri += '?' # The URI has a query string containing:
        $uri += @(
            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
        ) -join '&'

        # We want to decorate our return value.  Handily enough, both URIs contain a distinct name in the last URL segment.
        $typename = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') # We just need to drop the 's'
        $typeNames = @(
            "$organization.$typename"
            if ($Project) { "$organization.$Project.$typename" }
            "PSDevOps.$typename"
        )

        $invokeResult = Invoke-ADORestAPI -Uri $uri @invokeParams
        if ($invokeResult -is [string]) {
            $invokeResult = ($invokeResult -replace '""', '"_blank"') |
                Microsoft.PowerShell.Utility\ConvertFrom-Json |
                Select-Object -ExpandProperty Value
            $invokeResult = foreach ($ir in $invokeResult) {
                $ir.pstypenames.clear()
                foreach ($tn in $typeNames) {
                    $ir.pstypenames.Add($tn)
                }
                $ir
            }
        }

        $invokeResult |
            Add-Member NoteProperty Organization $Organization -Force -PassThru |
            Add-Member NoteProperty Server $Server -Force -PassThru
    }
}
