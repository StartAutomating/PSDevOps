function New-ADOWorkItem
{
    <#
    .Synopsis
        Creates new work items in Azure DevOps
    .Description
        Creates new work items in Azure DevOps or Team Foundation Server.
    .Example
        @{ Title='New Work Item'; Description='A Description of the New Work Item' } |
            New-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Type Issue
    .Link
        Invoke-ADORestAPI
    #>
    [CmdletBinding(DefaultParameterSetName='WorkItem',SupportsShouldProcess=$true)]
    [OutputType('PSDevOps.WorkItem')]
    param(
    # The InputObject
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
    [PSObject]
    $InputObject,

    # The type of the work item.
    [Parameter(Mandatory, ParameterSetName='WorkItem',ValueFromPipelineByPropertyName)]
    [Alias('WorkItemType')]
    [string]
    $Type,

    # If set, will create a shared query for work items.  The -InputObject will be passed to the body.
    [Parameter(Mandatory,ParameterSetName='SharedQuery',ValueFromPipelineByPropertyName)]
    [string]
    $QueryName,

    # If provided, will create shared queries beneath a given folder.
    [Parameter(ParameterSetName='SharedQuery',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='SharedQueryFolder',ValueFromPipelineByPropertyName)]
    [string]
    $QueryPath,

    # If provided, create a shared query with a given WIQL.
    [Parameter(Mandatory, ParameterSetName='SharedQuery',ValueFromPipelineByPropertyName)]
    [string]
    $WIQL,

    # If provided, the shared query created may be hierchical
    [Parameter(ParameterSetName='SharedQuery',ValueFromPipelineByPropertyName)]
    [ValidateSet('Flat','OneHop', 'Tree')]
    [string]
    $QueryType,

    # The recursion option for use in a tree query.
    [Parameter(ParameterSetName='SharedQuery',ValueFromPipelineByPropertyName)]
    [ValidateSet('childFirst','parentFirst')]
    [string]
    $QueryRecursiveOption,

    # If provided, create a shared query folder.
    [Parameter(Mandatory, ParameterSetName='SharedQueryFolder',ValueFromPipelineByPropertyName)]
    [string]
    $FolderName,

    # The work item ParentID
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
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

    # A collection of relationships for the work item.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
    [Alias('Relationships')]
    [Collections.IDictionary]
    $Relationship,

    # A list of comments to be added to the work item.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
    [PSObject[]]
    $Comment,

    # A list of tags to assign to the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Tag,

    # If set, will not validate rules.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
    [Alias('BypassRules','NoRules','NoRule')]
    [switch]
    $BypassRule,

    # If set, will only validate rules, but will not update the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ValidateRules','ValidateRule','CheckRule','CheckRules')]
    [switch]
    $ValidateOnly,

    # If set, will only validate rules, but will not update the work item.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='WorkItem')]
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

                if (-not $out.Url -and $restResponse.Url) {
                    $out.psobject.properties.add([PSNoteProperty]::new('Url', $restResponse.url))
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



        $q = [Collections.Queue]::new()
    }

    process {
        $q.Enqueue(@{PSParameterSet=$psCmdlet.ParameterSetName} + $PSBoundParameters)
    }

    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        $originalInvokeParams = $invokeParams
        while ($q.Count) {
            . $dq $q
            $uriBase = "$Server".TrimEnd('/'), $Organization, $Project -join '/'
            $invokeParams = @{} + $originalInvokeParams

            $c++
            Write-Progress "Creating" "$type [$c/$t]" -PercentComplete ($c * 100 / $t) -Id $progId
            $orgAndProject = @{Organization=$Organization;Project=$Project}
            $validFields =
                    if ($script:ADOFieldCache.$uribase) {
                        $script:ADOFieldCache.$uribase
                    } else {
                        Get-ADOField @orgAndProject -Server $Server @invokeParams
                    }

            if ($psParameterSet -in 'SharedQuery', 'SharedQueryFolder') {
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }

                $queryPathParts = @($QueryPath -split '/')
                $sharedQueries  = $null
                foreach ($qp in $queryPathParts) {
                    if (-not ($qp -as [guid])) {
                        $sharedQueries  = Get-ADOWorkItem -SharedQuery @orgAndProject -Depth 2
                        break
                    }
                }

                if ($sharedQueries) {
                    $queryPathId = $sharedQueries |
                       Where-Object Path -eq $QueryPath |
                       Select-Object -ExpandProperty ID
                    if (-not $queryPathId) {
                        Write-Error "Unable to find Query Path '$QueryPath'"
                        continue
                    } else {
                        $QueryPath = $queryPathId
                    }
                }

                $uri = $uriBase, "_apis/wit/queries", $(if ($QueryPath) { $QueryPath }) -ne '' -join '/'
                $uri = $uri.ToString().TrimEnd('/')
                $uri += '?' +
                    (@(
                        if ($ApiVersion) { "api-version=$ApiVersion" }
                        if ($validateOnly) { "validateWiqlOnly=true" }
                    ) -join '&')
                $invokeParams.uri = $uri

                $queryObject = @{}
                if ($psParameterSet -eq 'SharedQueryFolder') {
                    $queryObject['name'] = $FolderName
                    $queryObject['isFolder'] = $true
                    if ($QueryType) {
                        $queryObject['queryType'] = $QueryType
                    }
                    if ($queryRecursionOption) {
                        $queryObject['queryRecursionOption'] = $queryRecursionOption
                    }

                } else {
                    $queryObject['name'] = $QueryName
                    $queryObject['wiql'] = $WIQL

                }

                $invokeParams.Body = ConvertTo-Json $queryObject -Depth 100
                $invokeParams.Method = 'POST'
                $invokeParams.ContentType = 'application/json'
                $invokeParams.PSTypeName = @(
                    "$Organization.$psParameterSet"
                    "$Organization.$project.$psParameterSet"
                    "PSDevOps.$psParameterSet"
                )
                if ($WhatIfPreference) {
                    $invokeParams.Remove('PersonalAccessToken')
                    $invokeParams
                    continue
                }

                if (-not $PSCmdlet.ShouldProcess("POST $uri with $($invokeParams.body)")) { continue }
                $restResponse =  Invoke-ADORestAPI @invokeParams 2>&1
                $restResponse
                continue
            }


            $validFieldTable = $validFields | Group-Object ReferenceName -AsHashTable
            $uri = $uriBase, "_apis/wit/workitems", "`$$($Type)?" -join '/'
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

            if ($Tag) {
                $patchOperations += @{
                    op='add'
                    path ='/fields/system.tags'
                    value = $Tag -join ';'
                }
            }

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
            if ($Relationship) {# If we've been provided with a -Relationship.
                if ($Relationship.Keys -notlike '*.*') {
                    $relationshipTypes = Invoke-ADORestAPI -Uri $(@(
                        "$Server".TrimEnd('/'), $Organization, 'workitemrelationtypes'
                    ) -join '/') -Cache | Group-Object Name -AsHashTable # find out what type of Relationships exist.
                }
                :nextRelationship foreach ($kv in $Relationship.GetEnumerator()) { # Check out each relationship.
                    $relType =
                        if ($kv.Key -notlike '*.*') { # If we don't know that much about them,
                            if (-not $relationshipTypes[$kv.Key]) { # try to find their full name.
                                # If we couldn't, that's a yellow flag.
                                Write-Warning "$($kv.Key) is an unknown relationship type.  Valid types are: $($relationshipTypes | Select-Object -ExpandProperty Name)"
                                continue nextRelationship
                            }
                            $relationshipTypes[$kv.Key].ReferenceName
                        } else {
                            $kv.Key
                        }

                    $patchOperations += @{ # Forge the relationship.
                        op='add'
                        path ='/relations/-'
                        value = @{
                            rel = $relType
                            url = $kv.Value
                        }
                    }
                }
            }

            $invokeParams.Body = ConvertTo-Json $patchOperations -Depth 100
            $invokeParams.Method = 'POST'
            $invokeParams.ContentType = 'application/json-patch+json'
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $PSCmdlet.ShouldProcess("POST $uri with $($invokeParams.body)")) { continue }
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
                    $restResponse
                    continue
                }
            } elseif ($restResponse.Exception) {
                $restResponse
                continue
            }

            if (-not $restResponse.fields) { continue } # If the return value had no fields property, we're done.
            if (-not $Comment) {
                & $outWorkItem $restResponse
            } else {
                $outputtedWorkItem = & $outWorkItem $restResponse
                $null = foreach ($com in $Comment) {
                    $outputtedWorkItem.AddComment($com)
                }
                $outputtedWorkItem
            }
        }

        Write-Progress "Creating" "$type [$c/$t]" -Completed -Id $progId
    }
}