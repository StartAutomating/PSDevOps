function Set-ADOProject
{
    <#
    .Synopsis
        Sets properties of an Azure DevOps project
    .Description
        Sets metadata for an Azure DevOps project.
    .Link
        Get-ADOProject
    .Example
        Get-ADOProject -Organization MyOrganization |
            Set-ADOProject -Metadata @{
                Custom = 'Value'
            }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Nullable],[PSObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project identifier.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/FeatureManagement/FeatureStates/host/project/{ProjectID}/{FeatureId}',ValueFromPipelineByPropertyName)]
    [string]
    $ProjectID,

    # The ID of a feature to enable.
    [Parameter(ParameterSetName='/{Organization}/_apis/FeatureManagement/FeatureStates/host/project/{ProjectID}/{FeatureId}',ValueFromPipelineByPropertyName)]
    [string]
    $EnableFeature,

    # The ID of afeature to disable.
    [Parameter(ParameterSetName='/{Organization}/_apis/FeatureManagement/FeatureStates/host/project/{ProjectID}/{FeatureId}',ValueFromPipelineByPropertyName)]
    [string]
    $DisableFeature,

    # A dictionary of project metadata.
    [Parameter(ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties',ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Metadata,

    # The name of a metadata property.
    [Parameter(ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties',ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The value of a metadata property
    [Parameter(ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties',ValueFromPipelineByPropertyName)]
    [string]
    $Value,

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
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        $q.Enqueue(@{psParameterSet=$PSCmdlet.ParameterSetName} + $psBoundParameters)
    }

    end {
        $q.ToArray() |
            Group-Object { $_.PSParameterSet + ':' + $_.ProjectID }|
            ForEach-Object {
                $group = $_
                if ($group.Name -like '*/properties:*') {
                    $body = @(foreach ($g in $group.Group) {
                        if ($g.Name -and $g.Value) {
                            [Ordered]@{op='add';path = '/' + $g.Name.TrimStart('/');value=$g.Value}
                        }
                        elseif ($g.MetaData.Count) {
                            foreach ($kv in $g.Metadata.GetEnumerator()) {
                                [Ordered]@{op='add';path = '/' + $kv.Key.ToString().TrimStart('/');value=$kv.Value}
                            }
                        }
                    })
                    $invokeParams.Method = 'PATCH'
                    $invokeParams.ContentType = 'application/json-patch+json'
                }
                elseif ($group.Name -like '*FeatureStates*') {
                     if ($group.Group.EnableFeature -and $group.Group.disableFeature) {
                        Write-Error "Cannot enable and disable features in the same call."
                        return
                     }
                     $state = 0
                     $featureId =
                         if ($group.Group.EnableFeature) {
                            $state = 1
                            $group.Group.EnableFeature
                         }
                         elseif ($group.Group.DisableFeature) {
                            $group.Group.DisableFeature
                         }
                    $invokeParams.Method = 'PATCH'
                    $body = @{featureId=$featureId;scope=@{settingScope='project';userScoped=$false};state=$state}
                }

                if ($body) {
                    $uriBase, $null = $group.Name -split ':', 2
                    $uri = @(
                        "$server".TrimEnd('/')  # * The Server
                        . $ReplaceRouteParameter $uriBase
                    ) -join ''

                    $uri += '?'
                    $uri += @(
                        if ($Server -ne 'https://dev.azure.com' -and
                                -not $psBoundParameters['apiVersion']) {
                            $apiVersion = '2.0'
                        }
                        if ($ApiVersion) { # an api-version (if one exists)
                            "api-version=$ApiVersion"
                        }
                    ) -join '&'
                    $invokeParams.Uri = $uri
                    $invokeParams.body = $body
                    if ($WhatIfPreference) {
                        $invokeParams.Remove('PersonalAccessToken')
                        return $invokeParams
                    }
                    if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri) $($invokeParams.Body | ConvertTo-Json)")) {
                        Invoke-ADORestAPI @invokeParams -Property @{
                            Organization = $Organization
                            Server       = $server
                            ProjectID    = $ProjectID
                        }
                    }
                }
            }
    }
}
