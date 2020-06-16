function Get-ADOField
{
    <#
    .Synopsis
        Gets fields from Azure DevOps
    .Description
        Gets fields from Azure DevOps or Team Foundation Server.
    .Link
        New-ADOField
    .Link
        Remove-ADOField
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/fields/list?view=azure-devops-rest-5.1
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls")]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # If set, will force a refresh of the cached results.
    [Alias('Refresh')]
    [switch]
    $Force,

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        # Because fields don't change often,
        if (-not $Script:ADOFieldCache) { # if we haven't already created a cache
            $Script:ADOFieldCache = @{} # create a cache.
        }
    }

    process {
        # First, construct a base URI.  It's made up of:
        $uriBase = "$Server".TrimEnd('/'), # * The server
            $Organization, # * The organization
            $(if ($Project) { $project}) -ne $null -join
            '/'

        $uri = $uriBase, "_apis/wit/fields?" -join '/' # Next, add on the REST api endpoint
        if ($ApiVersion) { # If an -ApiVersion exists, add that to query parameters.
            $uri += "api-version=$ApiVersion"
        }
        $invokeParams.Uri = $uri

        if ($Force) { # If we're forcing a refresh
            $Script:ADOFieldCache.Remove($uriBase) # clear the cached results for $uriBase.
        }


        if (-not $Script:ADOFieldCache.$uriBase) { # If we have nothing cached,
            $typenames = @( # Prepare a list of typenames so we can customize formatting:
                if ($Organization -and $Project) {
                    "$Organization.$Project.Field" # * $Organization.$Project.Field (if $product exists)
                }
                "$Organization.Field" # * $Organization.Field
                'PSDevOps.Field' # * PSDevOps.Field
            )

            Write-Verbose "Caching ADO Fields for $uriBase"

            # Invoke the REST api
            $Script:ADOFieldCache.$uriBase =
                Invoke-ADORestAPI @invokeParams -PSTypeName $typenames -Property @{
                    Organization = $Organization
                    Project = $Project
                    Server = $Server
                } # decorate results with the Typenames,
            # and cache the result.
        }


        $Script:ADOFieldCache.$uriBase # Last but not least, output what was in the cache.
    }
}