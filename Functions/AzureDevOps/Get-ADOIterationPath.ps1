function Get-ADOIterationPath
{
    <#
    .Synopsis
        Gets iteration paths
    .Description
        Get iteration paths from Azure DevOps
    .Example
        Get-ADOIterationPath -Organization StartAutomating -Project PSDevOps
    .Link
        Get-ADOAreaPath
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/Classification%20Nodes/Get%20Classification%20Nodes?view=azure-devops-rest-5.1#get-the-root-area-tree
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/{Project}/_apis/wit/classificationnodes/Iterations')]
    [OutputType('PSDevOps.IterationPath')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project name or identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ProjectID')]
    [string]
    $Project,

    # The IterationPath
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $IterationPath,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 2.0.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "2.0",

    # The depth of items to get.  By default, one.
    [int]
    $Depth = 1
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        $expandIterationPaths = {
            param([Parameter(ValueFromPipeline)]$node)
            process {
                if ($node.structureType -ne 'iteration') { return }
                $node.pstypenames.clear()
                foreach ($typeName in "$organization.IterationPath",
                    "$organization.$Project.IterationPath",
                    "PSDevOps.IterationPath"
                ) {
                    $node.pstypenames.Add($typeName)
                }
                $node |
                    Add-Member NoteProperty Organization $organization -Force -PassThru |
                    Add-Member NoteProperty Project $Project -Force -PassThru |
                    Add-Member NoteProperty Server $Server -Force -PassThru
                if ($node.haschildren) {
                    $node.children |
                        & $MyInvocation.MyCommand.ScriptBlock
                }
            }
        }
    }
    process {
        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName) # and any parameterized URLs in this parameter set.
                if ($IterationPath) {
                    $IterationPath -replace '\\','/' -replace '.+/Iteration' -replace '^/'
                }
            ) -as [string[]] -ne '' -join '/'

        $uri += '?' # The URI has a query string containing:
        $uri += @(
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
            if ($Depth) {
                '$depth=' + $depth
            }
        ) -join '&'
        $typename = 'IterationPath'

        Invoke-ADORestAPI -Uri $uri @invokeParams | & $expandIterationPaths
    }
}