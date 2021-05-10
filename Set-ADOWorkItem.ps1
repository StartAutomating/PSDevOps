function Set-ADOWorkItem
{
    <#
    .Synopsis
        Sets work items from Azure DevOps
    .Description
        Sets work item from Azure DevOps or Team Foundation Server.
    .Example
        @{ 'Verb' ='Get' ;'Noun' = 'ADOWorkItem' } |
            Set-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 4
    .Example
        Set-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query "Select [System.ID] from WorkItems Where [System.State] = 'To Do' and [System.AssignedTo] = @Me" -InputObject @{
            State = 'Doing'
        }
    .Example
        Set-ADOWorkItem -Organization TestOrg -Project Test -ID 123 -InputObject @{
            Version = 'Updating Custom Version Field Despite Being Read Only'
        } -PersonalAccessToken $myPat -BypassRule
    .Link
        Invoke-ADORestAPI
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/update
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='ByID',SupportsShouldProcess=$true)]
    [OutputType('PSDevOps.WorkItem')]
    param(
    # The InputObject
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [PSObject]
    $InputObject,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Work Item ID
    [Parameter(Mandatory,ParameterSetName='ByID',ValueFromPipelineByPropertyName)]
    [string]
    $ID,

    # A query
    [Parameter(Mandatory,ParameterSetName='ByQuery',ValueFromPipelineByPropertyName)]
    [string]
    $Query,

    # The work item ParentID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParentID,

    # A collection of relationships for the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Relationships')]
    [Collections.IDictionary]
    $Relationship,

    # A list of comments to be added to the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $Comment,

    # A list of tags to assign to the work item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Tag,

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
        if ($PSCmdlet.ParameterSetName -eq 'ByID') {
            $q.Enqueue(@{PSParameterSet=$psCmdlet.ParameterSetName;} + $PSBoundParameters)
        } elseif ($PSCmdlet.ParameterSetName -eq 'ByQuery') {


            $uri = "$Server".TrimEnd('/'), $Organization, $Project, "_apis/wit/wiql?" -join '/'
            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            $uri +=
                @(if ($ApiVersion) {
                    "api-version=$ApiVersion"
                }) -join '&'

            $invokeParams.Method = "POST"
            $invokeParams.Body = ConvertTo-Json @{query=$Query}
            $invokeParams["Uri"] = $uri

            $queryResult = Invoke-ADORestAPI @invokeParams
            $c, $t, $progId  = 0, $queryResult.workItems.count, [Random]::new().Next()
            $myParams = @{} + $PSBoundParameters
            $myParams.Remove('Query')
            foreach ($wi in $queryResult.workItems) {
                $c++
                Write-Progress "Updating Work Items" " [$c of $t]" -PercentComplete ($c * 100 /$t) -Id $progId
                Set-ADOWorkItem @myParams -ID $wi.ID
            }

            Write-Progress "Updating Work Items" "Complete" -Completed -Id $progId
        }
    }

    end {
       $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q

            Write-Progress "Updating Work Items" " [$c of $t] $ID" -PercentComplete ($c * 100 /$t) -Id $progId

            $uriBase = "$Server".TrimEnd('/'), $Organization, $Project -join '/'
            $validFields =
                    if ($script:ADOFieldCache.$uribase) {
                        $script:ADOFieldCache.$uribase
                    } else {
                        Get-ADOField -Organization $Organization -Project $Project -Server $Server @invokeParams
                    }

            $validFieldTable = $validFields | Group-Object ReferenceName -AsHashTable
            $uri = $uriBase, "_apis/wit/workitems", "${ID}?" -join '/'

            $uri +=
                @(
                if ($ApiVersion) { "api-version=$ApiVersion" }
                if ($BypassRule) { 'bypassRules=true' }
                if ($SupressNotification) { 'supressNotifications=true'}
                if ($ValidateOnly) { 'validateOnly=true'}
                ) -join '&'


            if ($InputObject -is [Collections.IDictionary]) {
                $InputObject = [PSCustomObject]$InputObject
            }

            $patchOperations =
                @(foreach ($prop in $InputObject.psobject.properties) {
                    if ($MyInvocation.MyCommand.Parameters.Keys -contains $prop.Name) { continue }
                    & $fixField $prop $validFieldTable
                })

            if ($ParentID -or $Relationship) {
                $thisWorkItem =
                    Invoke-ADORestAPI -Uri "$uri&`$expand=relations" @invokeParams
            }

            if ($Tag) {
                $patchOperations += @{
                    op='add'
                    path ='/fields/system.tags'
                    value = $Tag
                }
            }

            if ($ParentID) {
                $c = 0
                $updates = @(foreach ($rel in $thisWorkItem.relations) {
                    if ($rel.rel -eq 'System.LinkTypes.Hierarchy-Reverse') {
                        @{
                            op = 'remove'
                            path = "/relations/$c"
                        }
                    }
                    $c++
                })

                if ($updates) {
                    $patchOperations += $updates
                }
                $patchOperations += @{
                    op='add'
                    path ='/relations/-'
                    value = @{
                        rel = 'System.LinkTypes.Hierarchy-Reverse'
                        url = $uriBase, '_apis/wit', $ParentID -join '/'
                    }
                }
            }

            if ($Relationship) { # If we've been provided with a -Relationship
                $relationshipTypes = Invoke-ADORestAPI -Uri $(@(
                    "$Server".TrimEnd('/'), $Organization, 'workitemrelationtypes'
                ) -join '/') -Cache | Group-Object Name -AsHashTable # find out what type of Relationships exist.

                $singleRelationshipTypes = @{}
                foreach ($k in @($relationshipTypes.Keys)) { # Then, find out which relationships are exclusive.
                    if ($relationshipTypes[$k].Attributes.SingleTarget) {
                        $singleRelationshipTypes[$relationshipTypes[$k].ReferenceName] = $relationshipTypes[$k]
                    }
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

                    $c =0
                    foreach ($rel in $thisWorkItem.relations) { # Check our existing relationships.
                        # If the new relationship already exists and must be exlusive
                        if ($relType -eq $rel.rel -and $singleRelationshipTypes[$rel.rel]) {
                            $patchOperations += @{ # then a breakup must occur before starting a new relationship.
                                op = 'remove'
                                path = "/relations/$c"
                            }
                        }
                        $c++
                    }

                    $patchOperations += @{ # Forge the new relationship.
                        op='add'
                        path ='/relations/-'
                        value = @{
                            rel = $relType
                            url = $kv.Value
                        }
                    }
                }
            }

            $invokeParams.Uri = $uri
            $invokeParams.Body = ConvertTo-Json $patchOperations -Depth 100
            $invokeParams.Method = 'PATCH'
            $invokeParams.ContentType = 'application/json-patch+json'
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                return $invokeParams
            }
            if (-not $PSCmdlet.ShouldProcess("Patch $uri with $($invokeParams.body)")) { return }
            $restResponse =  Invoke-ADORestAPI @invokeParams
            if (-not $restResponse.fields) { return } # If the return value had no fields property, we're done.
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

        Write-Progress "Updating Work Items" "Complete" -Completed -Id $progId

    }
}