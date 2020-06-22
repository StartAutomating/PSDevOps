function Get-ADOWorkItem
{
    <#
    .Synopsis
        Gets work items from Azure DevOps
    .Description
        Gets work item from Azure DevOps or Team Foundation Server.
    .Example
        Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 1
    .Example
        Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems'
    .Link
        Invoke-ADORestAPI
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/get%20work%20item?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/{Project}/{Team}/_apis/wit/wiql')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls")]
    param(
    # The Work Item Title
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Title,

    # A query
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/wit/wiql',ValueFromPipelineByPropertyName,Position=0)]
    [string]
    $Query = 'Select [System.ID] From WorkItems',

    # Gets work items assigned to me.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Me','My')]
    [switch]
    $Mine,

    # Gets work items in the current iteration.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CurrentSprint','ThisSprint')]
    [switch]
    $CurrentIteration,

    # If set, queries will output the IDs of matching work items.
    # If not provided, details will be retreived for all work items.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/wit/wiql',ValueFromPipelineByPropertyName)]
    [Alias('OutputID')]
    [switch]
    $NoDetail,

    # The Work Item ID
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/_apis/wit/workitems/{id}',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='/{Organization}/{Project}/_apis/wit/workitems/{id}/comments',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='/{Organization}/{Project}/_apis/wit/workItems/{id}/revisions',ValueFromPipelineByPropertyName)]
    [int]
    $ID,

    # If set, will get comments related to a work item.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/_apis/wit/workItems/{id}/comments',ValueFromPipelineByPropertyName)]
    [Alias('Comments')]
    [switch]
    $Comment,

    # If set, will get revisions of a work item.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/_apis/wit/workItems/{id}/revisions',ValueFromPipelineByPropertyName)]
    [Alias('Revisions')]
    [switch]
    $Revision,

    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Team.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/wit/wiql',ValueFromPipelineByPropertyName)]
    [string]
    $Team,

    # If set, will return work item types.
    [Parameter(Mandatory,ParameterSetName='WorkItemTypes',ValueFromPipelineByPropertyName)]
    [Alias('WorkItemTypes','Type','Types')]
    [switch]
    $WorkItemType,

    # One or more fields.
    [Alias('Fields','Select')]
    [string[]]
    $Field,

    # If set, will get related items
    [switch]
    $Related,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

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

        $allIDS = [Collections.ArrayList]::new()
    }

    process {
        $selfSplat = @{} + $PSBoundParameters
        $in = $_
        if ($PSCmdlet.ParameterSetName -eq 'ByTitle') {
            $selfSplat.Remove('Title')
            $selfSplat.Query = "Select [System.ID] from WorkItems Where [System.Title] contains '$title'"
            Get-ADOWorkItem @selfSplat
        }
        elseif (
            $PSCmdlet.ParameterSetName -in
            '/{Organization}/{Project}/_apis/wit/workitems/{id}',
            '/{Organization}/{Project}/_apis/wit/workitems/{id}/comments',
            '/{Organization}/{Project}/_apis/wit/workitems/{id}/revisions'
        ) {
            # Build the URI out of it's parts.
            $null = if (-not $id -and $in.Id) {
                $allIDS.Add($in.id)
            } else {
                $allIDS.Add($id)
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq '/{Organization}/{Project}/{Team}/_apis/wit/wiql')
        {
            $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName) + '?'
            $uri += if ($ApiVersion) {
                "api-version=$ApiVersion"
            }

            $realQuery = $Query
            if ($mine -or $CurrentIteration -or $Title -or $Project) {
                if ($realQuery -notlike '*where*') {
                    $realQuery += ' WHERE '
                } else {
                    $realQuery += ' AND '
                }


                $realQuery +=
                    @(
                    if ($Project) {
                        '[Team Project] = @Project'
                    }
                    if ($Title) {
                        "[System.Title] contains '$title'"
                    }
                    if ($Mine) {
                        '[System.AssignedTo] = @Me'
                    }
                    if ($CurrentIteration) {
                        '[System.IterationPath] = @currentIteration'
                    }) -join ' AND '
            }



            $invokeParams.Method = "POST"
            $invokeParams.Body = ConvertTo-Json @{query=$realQuery}
            $invokeParams["Uri"] = $uri

            $queryResults = Invoke-ADORestAPI @invokeParams |
                    Select-Object -ExpandProperty workItems
            if ($NoDetail) {
                foreach ($_ in $queryResults) {
                    $_.psobject.properties.add([PSNoteProperty]::new('Organization', $Organization))
                    $_.psobject.properties.add([PSNoteProperty]::new('Project', $Project))
                    $_.psobject.properties.add([PSNoteProperty]::new('Server', $Server))
                    $_.pstypenames.clear()
                    $_.pstypenames.Add("$organization.$project.WorkItem.ID")
                    $_.pstypenames.Add("PSDevOps.WorkItem.ID")
                    $_
                }
            } else {
                $selfSplat.Remove('Query')
                $queryResults |
                    Get-ADOWorkItem @selfSplat
            }
        } elseif ($PSCmdlet.ParameterSetName -eq 'WorkItemTypes') {
            $uri = "$Server".TrimEnd('/'), $Organization, $Project, "_apis/wit/workitemtypes?" -join '/'
            $uri += if ($ApiVersion) {
                "api-version=$ApiVersion"
            }
            $invokeParams.Uri =  $uri
            $workItemTypes = Invoke-ADORestAPI @invokeParams
            $workItemTypes -replace '"":', '"_blank":' |
                ConvertFrom-Json |
                Select-Object -ExpandProperty Value
        }
    }

    end {
        if (-not $allIDS.Count) { return }
        $av =
            if ($ApiVersion -and $ApiVersion.IndexOf('-') -ne -1) {
                $ApiVersion.Substring(0, $ApiVersion.IndexOf('-'))
            } else {
                $ApiVersion
            }
        $c, $t, $progID = 0, $allIDS.Count, [Random]::new().Next()
        if ($av -as [Version] -ge '5.1' -and $allIDS.Count -gt 1 -and -not ($Comment -or $Revision)) { # We can use WorkItemsBatch

            $uri = "$Server".TrimEnd('/'),
                $Organization,
                $(if ($Project) { $Project}),
                "_apis/wit/workitemsbatch?" -ne $null -join '/'
            $uri += "api-version=$ApiVersion"
            for ($c=0;$c -lt $allIDS.Count; $c+= 200) {
                $postBody = @{
                    ids = $allIDS[$c..($c + 199)]
                }
                if ($Field) {
                    $postBody.fields = $Field
                }
                if ($Related) {
                    $postBody.expand = 'relations'
                }
                $invokeParams.Uri = $uri
                $invokeParams.Method = 'POST'
                $invokeParams.Body = $postBody
                $p = $c * 100 / $t
                Write-Progress "Getting Work Items" "$c - $(($allIDS.Count - $c) % 200)" -PercentComplete $p -Id $progID
                foreach ($restResponse in Invoke-ADORestAPI @invokeParams) {
                    if ($field) {
                        $restResponse |
                        Add-Member NoteProperty ID $ID -PassThru
                    } else {
                        & $outWorkItem $restResponse
                    }
                }
            }
        } else {
            foreach ($id in $allIDS) {
                $c++
                $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName) + '?'
                $uri += @(if ($Field) { # If fields were provided, add it as a query parameter
                    "fields=$($Field -join ',')"
                }
                if ($Related) {
                    '$expand=relations'
                }
                if ($ApiVersion) { # If any api-version was provided, add it as a query parameter.
                    "api-version=$ApiVersion"
                }) -join '&'

                $invokeParams.Uri = $uri
                $p = $c * 100 / $t
                Write-Progress "Getting Work Items" "$id" -PercentComplete $p -Id $progid
                $restResponse = Invoke-ADORestAPI @invokeParams # Invoke the REST API.
                if (-not $restResponse.fields -and -not $Comment) { continue } # If the return value had no fields property, we're done.
                if ($field) {
                    $restResponse.fields |
                        Add-Member NoteProperty ID $ID -PassThru
                } elseif (-not $Comment) {
                    & $outWorkItem $restResponse
                } elseif ($restResponse.Comments) {
                    foreach ($wiComment in $restResponse.Comments) {
                        $wiComment.pstypenames.clear()
                        $wiComment.pstypenames.add("$Organization.WorkItem.Comment")
                        $wiComment | Add-Member NoteProperty Organization $Organization
                        if ($Project) {
                            $wiComment.pstypenames.add("$Organization.$Project.WorkItem.Comment")
                            $wiComment | Add-Member NoteProperty Project $Project
                        }
                        $wiComment.pstypenames.add('PSDevOps.WorkItem.Comment')
                        $wiComment
                    }
                }
            }
        }
        Write-Progress "Getting Work Items" "Complete" -Completed -Id $progID
    }
}