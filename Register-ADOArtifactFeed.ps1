function Register-ADOArtifactFeed
{
    <#
    .Synopsis
        Registers an Azure DevOps artifact feed.
    .Description
        Registers an Azure DevOps artifact feed as a PowerShell Repository.
        thThis allows Install-Module, Publish-Module, and Save-Module to work against an Azure DevOps artifact feed.
    .Link
        https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops
    .Link
        Get-ADOArtifactFeed
    .Link
        Unregister-ADOArtifactFeed
    .Link
        Get-PSRepository
    .Link
        Register-PSRepository
    .Link
        Unregister-PSRepository
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "",
        Justification="Abstracting Credential Structure is part of the point")]
    param(
    # The name of the organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The name or ID of the feed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('fullyQualifiedId')]
    [string]
    $FeedID,

    # The personal access token used to connect to the feed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('PAT')]
    [string]
    $PersonalAccessToken,

    # The email address used to connect
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $EmailAddress,

    # If provided, will create a repository source using a given name.
    # By default, the RepositoryName will be $Organization-$Project-$FeedID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryName,

    # If provided, will create a repository using a given URL.
    # By default, the RepositoryURL is predicted using -Organization, -Project, and -FeedID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryUrl,

    # If set, will remove the connection to an existing feed and then create a new one.
    [switch]
    $Force
    )


    begin {
        $psRepos = Get-PSRepository
    }
    process {
        #region Check if Repository Already Exists
        $targetName   = if ($RepositoryName) { $RepositoryName }
                        elseif ($Project) { "${Organization}-${Project}-${FeedID}" }
                        else { "${Organization}-${FeedID}" }
        $targetSource = if ($RepositoryUrl)  { $RepositoryUrl }
                        elseif ($Project) { "https://pkgs.dev.azure.com/$Organization/$Project/_packaging/$FeedID/nuget/v2" }
                        else { "https://pkgs.dev.azure.com/$Organization/_packaging/$FeedID/nuget/v2" }
        $psRepoExists = $psRepos  |
            Where-Object {
                $_.Name -eq $targetName -or
                $_.SourceLocation -eq $targetSource
            }

        if ($psRepoExists -and $Force) {
            $psRepoExists | Unregister-PSRepository
        } elseif ($psRepoExists) {
            Write-Verbose "Repository already exists: $($psRepoExists.Name)"
            return $psRepoExists
        }
        #endregion Check if Repository Already Exists

        #region Create Credential and Register-PSRepository
        if (-not $PersonalAccessToken -and $env:SYSTEM_ACCESSTOKEN) {
            $PersonalAccessToken = $env:SYSTEM_ACCESSTOKEN
        }

        if (-not $EmailAddress -and $PersonalAccessToken) {
            $EmailAddress = $PersonalAccessToken
        }

        if (-not $EmailAddress -and -not $PersonalAccessToken) {
            Write-Error "Must provide a -PersonalAccessToken.  Should provide an -EmailAddress"
            return
        }

        $repoCred = [Management.Automation.PSCredential]::new($EmailAddress, (ConvertTo-SecureString -AsPlainText -Force $PersonalAccessToken))

        Register-PSRepository -Name $targetName -SourceLocation $targetSource -PublishLocation $targetSource -InstallationPolicy Trusted -Credential $repoCred
        #endregion Create Credential and Register-PSRepository
    }
}
