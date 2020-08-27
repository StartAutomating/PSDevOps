function New-ADOWorkItem
{
    <#
    .Synopsis
        Creates new work items in Azure DevOps
    .Description
        Creates new work items in Azure DevOps or Team Foundation Server.
    .Example
        @{ 'Verb' ='Get' ;'Noun' = 'ADOWorkItem' } |
            Set-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 4
    .Link
        Invoke-ADORestAPI
    #>
    [CmdletBinding(DefaultParameterSetName='ByID',SupportsShouldProcess=$true)]
    param(
    # The InputObject
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [PSObject]
    $InputObject,

    # The type of the work item.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Alias('WorkItemType')]
    [string]
    $Type,

    # The work item ParentID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParentID,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # If set, will not validate rules.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('BypassRules','NoRules','NoRule')]
    [switch]
    $BypassRule,

    # If set, will only validate rules, but will not update the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ValidateRules','ValidateRule','CheckRule','CheckRules')]
    [switch]
    $ValidateOnly,

    # If set, will only validate rules, but will not update the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SuppressNotifications','SkipNotification','SkipNotifications','NoNotify')]
    [switch]
    $SupressNotification,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

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
        $fixField = {
            param($prop, $validFieldTable)

            $fieldName =
                if ($validFieldTable.Contains($prop.Name)) {
                    $validFieldTable[$prop.Name].ReferenceName
                } else {
                    $noSpacesPropName = $prop.Name -replace '\s', ''
                    foreach ($v in $validFieldTable.Values) {
                        if ($v.Name -replace '\s', '' -eq $noSpacesPropName -or
                            $v.referenceName -eq $noSpacesPropName) {
                            $v.referenceName
                            break
                        }
                    }
                }

            if (-not $fieldName) {
                Write-Warning "Could not map $($prop.Name) to a field"
                return
            }

            @{
                op = "add"
                path = '/fields/' + $fieldName
                value = $prop.Value
            }

        }

        #region Output Work Item
        $outWorkItem = {
            param([Parameter(ValueFromPipeline)]$restResponse)
            process {
                $out = $restResponse.fields
                if (-not $out.ID) {
                    $out.psobject.properties.add([PSNoteProperty]::new('ID', $restResponse.ID))
                }
                if (-not $out.Relations -and $restResponse.Relations) {
                    $out.psobject.properties.add([PSNoteProperty]::new('Relations', $restResponse.Relations))
                }
                if (-not $out.Organization -and $Organization) {
                    $out.psobject.properties.add([PSNoteProperty]::new('Organization', $Organization))
                }
                if (-not $out.Project -and $Project) {
                    $out.psobject.properties.add([PSNoteProperty]::new('Project', $Project))
                }

                $out.pstypenames.clear() # and we want them to by formattable, we we give them the following typenames
                $wiType = $out.'System.WorkItemType'
                if ($workItemType) {
                    #* $Organization.$Project.$WorkItemType (If Output had WorkItemType).
                    $out.pstypenames.add("$Organization.$Project.$wiType")
                }
                #* $Organization.$Project.WorkItem.
                $out.pstypenames.add("$Organization.$Project.WorkItem")
                if ($workItemType) { #* PSDevOps.$WorkItemType (if output had workItemType).
                    $out.pstypenames.add("PSDevOps.$wiType")
                }
                $out.pstypenames.add("PSDevOps.WorkItem") #* PSDevOps.WorkItem
                # Decorating the object this way allows it to be generically formatted by the PSDevOps module
                $out # and specifically formatted for a given org/project/workitemtype.
            }
        }
        #endregion Output Work Item
    }

    process {
        $uriBase = "$Server".TrimEnd('/'), $Organization, $Project -join '/'

        $validFields =
                if ($script:ADOFieldCache.$uribase) {
                    $script:ADOFieldCache.$uribase
                } else {
                    Get-ADOField -Organization $Organization -Project $Project -Server $Server @invokeParams
                }

        $validFieldTable = $validFields | Group-Object ReferenceName -AsHashTable
        $uri = $uriBase, "_apis/wit/workitems", "`$$($Type -replace '\s', '')?" -join '/'
        if ($Server -ne 'https://dev.azure.com/' -and
            -not $PSBoundParameters.ApiVersion) {
            $ApiVersion = '2.0'
        }
        $uri +=
            @(
            if ($ApiVersion) {"api-version=$ApiVersion" }
            if ($BypassRule) { 'bypassRules=true' }
            if ($SupressNotification) { 'supressNotifications=true'}
            if ($ValidateOnly) { 'validateOnly=true'}
            ) -join '&'



        $invokeParams.Uri = $uri

        if ($InputObject -is [Collections.IDictionary]) {
            $InputObject = [PSCustomObject]$InputObject
        }

        $patchOperations =
            @(foreach ($prop in $InputObject.psobject.properties) {
                if ($MyInvocation.MyCommand.Parameters.Keys -contains $prop.Name) { continue }
                & $fixField $prop $validFieldTable
            })

        if ($parentID) {
            $patchOperations += @{
                op='add'
                path ='/relations/-'
                value = @{
                    rel = 'System.LinkTypes.Hierarchy-Reverse'
                    url = $uriBase, '_apis/wit', $ParentID -join '/'
                }
            }
        }

        $invokeParams.Body = ConvertTo-Json $patchOperations -Depth 100
        $invokeParams.Method = 'POST'
        $invokeParams.ContentType = 'application/json-patch+json'
        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }
        if (-not $PSCmdlet.ShouldProcess("POST $uri with $($invokeParams.body)")) { return }
        $restResponse =  Invoke-ADORestAPI @invokeParams 2>&1

        if ($restResponse.ErrorDetails.Message) {
            $errorDetails = $restResponse.ErrorDetails.Message | ConvertFrom-Json
            if ($errorDetails.message -like 'VS402323*') {
                $PSCmdlet.WriteError([Management.Automation.ErrorRecord]::new(
                        [Exception]::new(
                            $errorDetails.message + [Environment]::NewLine +
                            "Use Get-ADOWorkItem -WorkItemType to find valid types"
                        ),'UnknownWorkItemType', 'NotSpecified', $restResponse)
                )

            } else {
                return $restResponse
            }
        } elseif ($restResponse.Exception) {
            return $restResponse
        }

        if (-not $restResponse.fields) { return } # If the return value had no fields property, we're done.
        & $outWorkItem $restResponse
    }
}