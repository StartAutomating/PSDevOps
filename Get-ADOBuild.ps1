function Get-ADOBuild
{
    <#
    .Synopsis
        Gets Azure DevOps Builds, Definitions, and associated information.
    .Description
        Gets Azure DevOps Builds or Definitions and associated information.

        Gets builds by default.  To get build definitions, use -Definition

        Given a -BuildID, we can can get associated information:

        |Parameter | Effect                                       |
        |----------|----------------------------------------------|
        |-Artfiact      |  Get a list of all build artifacts      |
        |-ChangeSet     |  Get the build's associated changeset   |
        |-Log           |  Get a list of all build logs           |
        |-LogID         |  Get the content of a specific LogID    |
        |-Timeline      |  Gets the build timeline                |
        |-BuildMetaData | Returns system metadata about the build |

        Given a -Definition ID, we can get associated information:

        |Parameter | Effect                                           |
        |----------|--------------------------------------------------|
        |-Status            | Gets the status of the build definition |
        |-Metric            | Gets metrics about the build definition |
        |-Revision          | Gets the revisions of a build definition|
        |-DefinitionMetadata| Gets metadata about a build definition  |
    .Example
        Get-ADOBuild -Organization StartAutomating -Project PSDevOps
    .Example
        Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/artifacts/list?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get%20build%20logs?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/timeline/get?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20build%20properties?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/get?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20definition%20properties?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/metrics/get%20definition%20metrics?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='build/builds')]
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

    # The server.  By default https://feeds.dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    [string]
    $ApiVersion = "5.1-preview",

    # Build ID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/properties',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/logs',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/logs/{logId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/changes',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/artifacts',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/timeline',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/report',ValueFromPipelineByPropertyName)]
    [string]
    $BuildID,

    # If set
    [Parameter(ParameterSetName='build/builds/{buildId}')]
    [Alias('Details')]
    [switch]
    $Detail,

    # If set, returns system metadata about the -BuildID.
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/properties',ValueFromPipelineByPropertyName)]
    [switch]
    $BuildMetadata,

    # If set, will get artifacts from -BuildID.
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/artifacts',ValueFromPipelineByPropertyName)]
    [Alias('Artifacts')]
    [switch]
    $Artifact,

    # If set, will get a list of logs associated with -BuildID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/logs')]
    [Alias('Logs')]
    [switch]
    $Log,

    # If provided, will retreive the specific log content of -BuildID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/logs/{logId}',ValueFromPipelineByPropertyName)]
    [string]
    $LogID,

    # If set, will return the changeset associated with the build -BuildID.
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/changes')]
    [switch]
    $ChangeSet,

    # If set, will return the build report associated with -BuildID.
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/report')]
    [switch]
    $Report,

    # If set, will return the timeline for build -BuildID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}/timeline')]
    [switch]
    $Timeline,

    # If set, will get build definitions.
    [Parameter(Mandatory,ParameterSetName='build/definitions')]
    [switch]
    $Definition,

    # If set, will get a specific build by definition ID
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/properties',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/metrics',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/revisions',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/status/{definitionId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/resources',ValueFromPipelineByPropertyName)]
    [string]
    $DefinitionID,

    # If set, will get the status of a defined build.
    [Parameter(Mandatory,ParameterSetName='build/status/{definitionId}')]
    [Alias('DefinitionStatus')]
    [switch]
    $Status,

    # If set, will get definition properties
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/properties')]
    [switch]
    $DefinitionMetadata,

    # If set, will get revisions to a build definition.
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/revisions')]
    [Alias('DefinitionRevisions','DefinitionRevision','Revisions')]
    [switch]
    $Revision,

    # If set, will get authorized resources for a build definition.
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/resources')]
    [switch]
    $Resource,

    # If set, will get metrics about a build definition.
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}/metrics')]
    [Alias('DefinitionMetric','DefinitionMetrics','Metrics')]
    [switch]
    $Metric,

    # If provided, will get the first N builds or build definitions
    [Parameter(ParameterSetName='build/builds')]
    [Parameter(ParameterSetName='build/definitions')]
    [Alias('Top')]
    [Uint32]
    $First,

    # If provided, will only return builds for a given branch.
    [Parameter(ParameterSetName='build/builds')]
    [string]
    $BranchName,

    # If provided, will only return builds one of these tags.
    [Parameter(ParameterSetName='build/builds')]
    [string[]]
    $Tag,

    # If provided, will only return builds queued after this point in time.
    [Parameter(ParameterSetName='build/builds')]
    [Alias('MinTime')]
    [DateTime]
    $After,

    # If provided, will only return builds queued before this point in time.
    [Parameter(ParameterSetName='build/builds')]
    [Alias('MaxTime')]
    [DateTime]
    $Before,

    # If provided, will only return builds with this result.
    [Parameter(ParameterSetName='build/builds')]
    [ValidateSet('Canceled','Failed','None','Succeeded','PartiallySucceeded')]
    [string]
    $BuildResult,

    # If provided, will only return build definitions that have been built after this date.
    [Parameter(ParameterSetName='build/definitions')]
    [DateTime]
    $BuiltAfter,

    # If provided, will only return build definitions that have not been built since this date.
    [Parameter(ParameterSetName='build/definitions')]
    [Alias('NotBuiltAfter')]
    [DateTime]
    $NotBuiltSince,

    # If provided, will return build definition YAML.  No other information will be returned.
    [Parameter(ParameterSetName='build/definitions/{definitionId}')] 
    [switch]
    $DefinitionYAML)
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $authParams = @{} + $invokeParams

        $accumulatedInput = [Collections.ArrayList]::new()
    }
    
    process {
        $in = $_
        $ParameterSet = $psCmdlet.ParameterSetName
        if ($ParameterSet -eq $MyInvocation.MyCommand.DefaultParameterSet) {
            if ($in.BuildID) {
                $ParameterSet = 'build/builds/{buildId}'
                $buildID = $in.BuildID
            } elseif ($in.DefinitionID) {
                $ParameterSet = 'build/definitions/{definitionId}'
                $definitionID = $in.DefinitionID
            }
        }

        $null = $accumulatedInput.Add(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }

    end {
        $c, $t, $id = 0, $accumulatedInput.Count, [Random]::new().Next()
        foreach ($acc in $accumulatedInput) {
            foreach ($kv in $acc.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.set($kv.Key, $kv.Value)
            }
            if ($t -gt 1) {
                $c++
                Write-Progress "Getting Builds" "$server $Organization $Project" -Id $id -PercentComplete ($c * 100/$t)
            }
            $invokeParams.Uri = # First construct the URI.  It's made up of:
                "$(@(
                    "$server".TrimEnd('/') # * The Server
                    $Organization # * The Organization
                    $Project # * The Project
                    '_apis' #* '_apis'
                    . $ReplaceRouteParameter $ParameterSet #* and the replaced route parameters.
                )  -join '/')?$( # Followed by a query string, containing
                @(
                    if ($First) {
                        "`$top=$first"
                    }
                    if ($BranchName) {
                        if ($BranchName -notlike '*/*') {
                            $BranchName = "refs/heads/$branchName"
                        }
                        "branchName=$branchName"
                    }
                    if ($After) {
                        "minTime=$($after.tolocalTime().ToString('o'))"
                    }
                    if ($before) {
                        "maxTime=$($before.ToLocalTime().ToString('o'))"
                    }
                    if ($BuiltAfter) {
                        "builtAfter=$($BuiltAfter.ToLocalTime().ToString('o'))"
                    }
                    if ($NotBuiltSince) {
                        "notBuiltAfter=$($NotBuiltSince.ToLocalTime().ToString('o'))"
                    }
                    if ($tag) {
                        "tagFilters=$($tag -join ',')"
                    }

                    if ($BuildResult) {
                        "resultFilter=$buildResult"
                    }
                    if ($Server -ne 'https://dev.azure.com/' -and 
                        -not $PSBoundParameters.ApiVersion) {
                        $ApiVersion = '2.0'
                    }
                    if ($ApiVersion) { # an api-version (if one exists)
                        "api-version=$ApiVersion"
                    }
                ) -join '&'
                )"

            $subtypename = @($parameterSet -replace '/{\w+}', '' -split '/')[-1].TrimEnd('s')
            $subtypeName =
                if ($subtypename -eq 'Build') {
                    ''
                } else {
                    '.' + $subtypename.Substring(0,1).ToUpper() + $subtypename.Substring(1)
                }
            $invokeParams.PSTypeName = @( # Prepare a list of typenames so we can customize formatting:
                "$Organization.$Project.Build$subTypeName" # * $Organization.$Project.Build
                "$Organization.Build$subTypeName" # * $Organization.Build
                "PSDevOps.Build$subTypeName" # * PSDevOps.Build
            )

        
            if ($Detail)
            {
                $null = $PSBoundParameters.Remove('Detail')
                Invoke-ADORestAPI @invokeParams -Property @{
                    Organization = $Organization
                    Project = $Project
                } |
                    Add-Member NoteProperty ChangeSet -Value (Get-ADOBuild @PSBoundParameters -ChangeSet) -Force -PassThru |
                    Add-Member NoteProperty Timeline -Value (Get-ADOBuild @PSBoundParameters -Timeline) -Force -PassThru |
                    Add-Member NoteProperty Artifacts -Value (Get-ADOBuild @PSBoundParameters -Artifact) -Force -PassThru |
                    Add-Member NoteProperty Logs -Value (Get-ADOBuild @PSBoundParameters -Log) -Force -PassThru
            } 
            elseif ($DefinitionYAML)
            {
                $definitionObject = Invoke-ADORestAPI @invokeParams
                if ($definitionObject.process.yamlFileName) {
                    $repoParams = @{
                        Organization = $Organization
                        Project = $Project
                        ProviderName = $definitionObject.repository.type
                        RepositoryName = $definitionObject.repository.name
                        Path = $definitionObject.process.yamlfilename
                        CommitOrBranch = $definitionObject.repository.defaultBranch
                    }
                    if ($definitionObject.repository.properties.connectedServiceId) {
                        $repoParams.EndpointId = $definitionObject.repository.properties.connectedServiceId
                    }
                    # Get the repository, and redirect errors into output.
                    Get-ADORepository @repoParams @authParams 2>&1 | # This way, we can add properties:
                        Add-Member NoteProperty Organization $Organization -Force -PassThru | # * .Organization
                        Add-Member NoteProperty Project $Project -Force -PassThru |  # .Project 
                        Add-Member NoteProperty DefinitionID $definitionObject.ID -Force -PassThru | # .DefinitionID
                        Add-Member NoteProperty DefinitionName $definitionObject.Name -Force -PassThru # .DefinitionName
                }
            } 
            else
            {
                Invoke-ADORestAPI @invokeParams -Property @{
                    Organization = $Organization
                    Project = $Project
                    Server = $Server
                }
            }
        }
        if ($t -gt 1) {
            $c++
            Write-Progress "Getting Builds" "$server $Organization $Project" -Id $id -Completed
        }
    }
}