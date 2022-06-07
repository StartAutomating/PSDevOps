function Start-ADOBuild
{
    <#
    .Synopsis
        Starts an Azure DevOps Build
    .Description
        Starts a build in Azure DevOps, using an existing BuildID,
    .Link
        Get-ADOBuild
    .Link
        Stop-ADOBuild
    .Example
        Get-ADOBuild -Definition -Organization StartAutomating -Project PSDevOps |
            Start-ADOBuild -WhatIf
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/queues
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('PSDevOps.Build',[Hashtable])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired")]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The server.  By default https://dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    [string]
    $ApiVersion = "5.1",

    # The Build ID
    [Parameter(Mandatory,ParameterSetName='BuildID',ValueFromPipelineByPropertyName)]
    [string]
    $BuildID,

    # The Build Definition ID
    [Parameter(Mandatory,ParameterSetName='DefinitionId',ValueFromPipelineByPropertyName)]
    [string]
    $DefinitionID,

    # The Build Definition Name
    [Parameter(Mandatory,ParameterSetName='DefinitionName',ValueFromPipelineByPropertyName)]
    [string]
    $DefinitionName,

    # The source branch (the branch used for the build).
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $SourceBranch,

    # The source version (the commit used for the build).
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $SourceVersion,

    # The build parameters
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters')]
    [PSObject]
    $Parameter)

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $goSplat = @{Organization=$Organization;Project=$Project} + $invokeParams


        $invokeParams.Uri = # First construct the URI.  It's made up of:
            "$(@(
                "$server".TrimEnd('/') # * The Server
                $Organization # * The Organization
                $Project # * The Project
                '_apis' #* '_apis'
                'build', #* 'build'
                'builds' #* and 'builds'
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"

        $invokeParams.Body = @{}

        if ($DefinitionID) {
            $invokeParams.Body.Definition = @{}
            $invokeParams.Body.Definition.ID = $DefinitionID
        } elseif ($BuildID) {
            $build = Get-ADOBuild -BuildID $BuildID @goSplat
            $invokeParams.Body.Definition = @{}
            $invokeParams.Body.Definition.ID = $build.definition.id
        } elseif ($DefinitionName) {
            $defs = Get-ADOBuild -definition @goSplat |
                Where-Object { $_.Name -like $DefinitionName } |
                Select-Object -First 1
            $invokeParams.Body.Definition = @{}
            $invokeParams.Body.Definition.ID = $defs.ID
        }

        if (-not $invokeParams.Body.Definition.ID) { return}

        if ($SourceBranch) {
            $invokeParams.Body.SourceBranch = $SourceBranch
        }
        if ($SourceVersion) {
            $invokeParams.Body.SourceVersion = $SourceVersion
        }

        if ($DebugPreference -ne 'silentlycontinue') {
            if (-not $Parameter) {
                $Parameter = @{'System.DebugContext'=$true}
            }
            elseif ($Parameter -is [Collections.IDictionary]) {
                $Parameter['System.DebugContext'] = $true
            }
            else {
                $Parameter | Add-Member NoteProperty System.DebugContext $true -Force
            }
        }

        if ($Parameter) {
            if ($Parameter -isnot [string]) {
                $Parameter = $Parameter | ConvertTo-Json -Depth 100
            }
            $invokeParams.Body.Parameters = $Parameter
        }


        $invokeParams.PSTypeName = @( # Prepare a list of typenames so we can customize formatting:
            "$Organization.$Project.Build" # * $Organization.$Project.Build
            "$Organization.Build" # * $Organization.Build
            "PSDevOps.Build" # * PSDevOps.Build
        )

        $invokeParams.Method = 'POST'

        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams -Property @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
        }
    }
}
