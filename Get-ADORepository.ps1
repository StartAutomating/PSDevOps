function Get-ADORepository
{
    <#
    .Synopsis
        Gets repositories from Azure DevOps
    .Description
        Gets the repositories from Azure DevOps.

        By default, this will return the project's git repositories.

        Azure DevOps repositories can have more than one type of SourceProvider.

        To list the Source Providers, use -SourceProvider

        We can get repositories for a given -ProviderName
    .Example
        Get-ADORepository -Organization StartAutomating -Project PSDevOps
    .Link
        Remove-ADORepository
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/source%20providers/list%20repositories?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='git/repositories')]
    [OutputType('PSDevOps.Repository',
        'PSDevOps.Repository.SourceProvider',
        'PSDevOps.Repository.File',
        'PSDevOps.Repoistory.Recycled')]
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

    # The Repository ID
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryID,

    # If set, will list repository source providers
    [Parameter(Mandatory,ParameterSetName='sourceproviders',ValueFromPipelineByPropertyName)]
    [Alias('SourceProviders')]
    [switch]
    $SourceProvider,

    # The name of the Source Provider.  This will get all repositories associated with the project.
    # If the -ProviderName is not TFVC or TFGit, an -EndpointID is also required
    [Parameter(Mandatory,ParameterSetName='sourceproviders/{ProviderName}/repositories',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [Alias('EndpointType')]
    [string]
    $ProviderName,

    # The name of the Source Provider.  This will get all repositories associated with the project.
    # If the -ProviderName is not TFVC or TFGit, an -EndpointID is also required
    [Parameter(ParameterSetName='sourceproviders/{ProviderName}/repositories',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $EndpointID,

    # The name of the repository
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryName,

    # The path within the repository.
    # To use this parameter, -ProviderName is also required, and -EndpointID will be required if the -ProviderName is not TFVC or TFGit
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $Path,

    # The commit or branch.  By default, Master.
    [Parameter(ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $CommitOrBranch = 'master',

    # If set, will get the file list from a repository
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('Item','Items','Files')]
    [switch]
    $FileList,

    # When getting a -FileList, the recursion level.  By default, full.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('full','None','oneLevel','oneLevelPlusNestedEmptyFolders')]
    [string]
    $RecursionLevel = 'full',

    # When getting a -FileList, the path scope.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('PathScope')]
    [string]
    $ScopePath,

    # The version string identifier (name of tag/branch, SHA1 of commit)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('Version')]
    [string]
    $VersionDescriptor,

    # The version options (e.g. firstParent, previousChange)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('none','firstParent','previousChange')]
    [string]
    $VersionOption,

    # The version type (e.g. branch, commit, or tag)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('branch','commit','tag')]
    [string]
    $VersionType,

    # If -IncludeContentMetadata is set a -FileList will include content metadata.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('IncludeContentMetadata')]
    [switch]
    $IncludeMetadata,

    # If set, will include the parent repository
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [switch]
    $Download,

    # If set, will list pull requests related to a git repository.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('PR')]
    [switch]
    $PullRequest,

    # Filters pull requests, returning requests created by the -CreatorIdentity.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('CreatorID')]
    [string]
    $CreatorIdentity,

    # Filters pull requests where the -ReviewerIdentity is a reviewer.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('ReviewerID')]
    [string]
    $ReviewerIdentity,

    # Filters pull requests where the source branch is the -SourceReference.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('SourceRef','SourceRefName')]
    [string]
    $SourceReference,

    # Filters pull requests where the target branch is the -TargetReference.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('TargetRef','TargetRefName')]
    [string]
    $TargetReference,

    # If set, will include the parent repository
    [Parameter(ParameterSetName='git/repositories/{repositoryId}',ValueFromPipelineByPropertyName)]
    [switch]
    $IncludeParent,

    # If set, will get repositories from the recycle bin
    [Parameter(Mandatory,ParameterSetName='git/recycleBin/repositories',ValueFromPipelineByPropertyName)]
    [Alias('RecycleBin')]
    [switch]
    $Recycled,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = & $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        $q = [Collections.Queue]::new()

    }

    process {
        $q.Enqueue(@{psParameterSet= $psCmdlet.ParameterSetName} + $psBoundParameters)

    }

    end {
        $c, $t, $progId =0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $DQ $q
            if ($t -gt 1) {
                $c++
                Write-Progress "Getting Repositories" "$Server $Organization/$Project" -PercentComplete ($c * 100 / $t) -Id $progId
            }

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/') # the Server (minus any trailing slashes),
                    $Organization          # the Organization,
                    $Project               # the Project,
                    '_apis'                # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $PSParameterSet)
                                           # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'
            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($IncludeParent) { # includeParent=True (if it was set)
                    "includeParent=True"
                }

                if ($EndpointID) {
                    "serviceEndpointId=$EndpointID"
                }

                if ($repositoryName) {
                    "repository=$repositoryName"
                    "commitOrBranch=$CommitOrBranch"
                }

                if ($psParameterSet -eq 'git/repositories/{repositoryId}/items') {
                    if ($IncludeMetadata) {
                        "includeContentMetadata=true"
                    }
                    if ($RecursionLevel) {
                        "recursionLevel=$recursionLevel"
                    }
                    if ($Download) {
                        "download=true"
                    } else {
                        '$format=json'
                    }

                    if ($scopePath) {
                        "scopePath=$scopePath"
                    }

                    if ($Latest) {
                        "latestProcessedChange=true"
                    }
                    if ($VersionDescriptor) {
                        "versionDescriptor.version=$VersionDescriptor"
                    }
                    if ($VersionOption) {
                        "versionDescriptor.option=$VersionOption"
                    }
                    if ($VersionType) {
                        "versionDescriptor.type=$VersionType"
                    }
                }
                elseif ($psParameterSet -eq 'git/repositories/{repositoryId}/items') {
                    if ($SourceReference) {
                        "searchCriteria.sourceRefName=$SourceReference"
                    }
                    if ($TargetReference) {
                        "searchCriteria.targetRefName=$TargetReference"
                    }
                    if ($CreatorIdentity) {
                        "searchCriteria.creatorId=$CreatorIdentity"
                    }
                    if ($ReviewerIdentity) {
                        "searchCriteria.reviewerID=$ReviewerIdentity"
                    }
                }

                if ($path) {
                    "path=$path"
                }
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # and the apiVersion
                    "api-version=$ApiVersion"
                }
            ) -join '&'

            $InvokeParams.Property =
                @{
                    # Because we want to pipeline properly, also return the -Organization and -Project as properties.
                    Organization = $Organization
                    Project = $Project
                    Server = $Server
                }

            $subTypeName =
                if ($psParameterSet -eq 'git/recycleBin/repositories') {
                    '.Recycled'
                }
                elseif ($psParameterSet -eq 'sourceProviders') {
                    '.SourceProvider'
                }
                elseif ($psParameterSet -eq 'sourceproviders/{ProviderName}/repositories') {
                    ".$ProviderName.Repository"
                    $invokeParams.ExpandProperty = 'repositories'
                    $invokeParams.Property.EndpointID = $EndpointID
                    $invokeParams.Property.ProviderName = $ProviderName
                }
                elseif ($psParameterSet -eq 'git/repositories/{repositoryId}/items') {
                    ".File"
                }
                elseif ($psParameterSet -eq 'git/repositories/{repositoryId}/pullrequests') {
                    ".PullRequest"
                }
                else {
                    ''
                }

            # Invoke the ADO Rest API.
            Invoke-ADORestAPI @invokeParams -Uri $uri -PSTypeName @(
                # Because we want to format the output, decorate the object with the following typenames:
                "$Organization.$Project.Repository$subTypeName" # * $Organization.$Project.Repository$SubTypeName
                "$Organization.Repository$subTypeName" # * $Organization.Repository$SubTypeName
                "PSDevOps.Repository$subTypeName" # * PSDevOps.Repository$SubTypeName
            )
        }

        Write-Progress "Getting Repositories" ' ' -Completed -Id $progId
    }
}
