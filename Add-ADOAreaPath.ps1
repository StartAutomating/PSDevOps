function Add-ADOAreaPath
{
    <#
    .Synopsis
        Adds an Azure DevOps AreaPath
    .Description
        Adds an Azure DevOps AreaPath.  AreaPaths are used to logically group work items within a project.
    .Example
        Add-ADOAreaPath -Organization MyOrg -Project MyProject -AreaPath MyAreaPath
    .Example
        Add-ADOAreaPath -Organization MyOrg -Project MyProject -AreaPath MyAreaPath\MyNestedPath
    .Link
        Get-ADOAreaPath
    .Link
        Remove-ADOAreaPath
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('PSDevOps.AreaPath')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The AreaPath.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $AreaPath,

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

        $q = [Collections.Queue]::new() # Collect input in a queue
    }

    process {
        $q.Enqueue(@{} + $psboundParameters) # enqueue new input.
    }

    end {
        $c,$t, $id = 0, $q.Count, [Random]::new().Next()
        $allAreaPaths = @{}
        #region Until the Queue is Empty
        while ($q.Count) {
            $qi = $q.Dequeue() # Dequeue each item.
            $getAreaPathParams = @{} + $qi # Prepare input for Get-ADOAreaPath
            $getAreaPathParams.Remove('AreaPath')
            foreach ($kv in $qi.GetEnumerator()) { # Repopulate the input parameters.
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }
            if ($t -gt 1) {
                $c++
                Write-Progress "Adding Area Paths" "$AreaPath " -PercentComplete ($c * 100 / $t) -Id $id
            }
            $areaPathParts= @($areaPath -split '\\')
            if (-not $allAreaPaths["$Organization/$Project"]) { # Cache ADO Area Paths
                $allAreaPaths["$Organization/$Project"] = @(Get-ADOAreaPath @getAreaPathParams)
            }

            $existingAreaPath = $null
            $closestAreaPath  = $null
            $areaPathCache    = $allAreaPaths["$Organization/$Project"]
            foreach ($path in $areaPathCache) { # See If the path already exists, or where we can put it in the hierarchy.
                if ($path.Path -eq "\$project\Area\$AreaPath") {
                    $existingAreaPath = $path
                }
                elseif ($areaPathParts.Count -gt 1) {
                    for ($i = ($areaPathParts.Count - 2); $i -ge 0; $i--) {
                        if ($path.Path -like "\$Project\Area\$($areaPathParts[0..$i] -join '\')") {
                            $closestAreaPath = $path.Path
                            break
                        }
                    }
                }
            }

            if ($existingAreaPath) { # If it already existed, write it to Verbose.
                Write-Verbose "AreaPath: '\$Project\Area\$areaPath' already exists"
                continue
            }

            $body = @{name = $areaPathParts[-1]} # Prepare the input body

            $base = "/{Organization}/{Project}/_apis/wit/classificationNodes/Areas"
            if ($closestAreaPath) { # If we had a closest path,

                $firstSlash, $projectPart, $areaPart, $closestPart = # split up the AreaPath
                    $closestAreaPath -split '\\', 4
                $base += "/$closestPart" # and add the subpath to the base.
            }

             $uri =
                $Server.ToString().TrimEnd('/') +
                (. $ReplaceRouteParameter $base) +
                '?' + $(
                    if ($Server -ne 'https://dev.azure.com' -and -not $psBoundParameters['apiVersion']) {
                        $apiVersion = "2.0"
                    }
                    if ($ApiVersion) {
                        "api-version=$ApiVersion"
                    }
                )

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'POST'
            $invokeParams.Body = $body

            if ($WhatIfPreference) { # If we passed -WhatIf
                $invokeParams.Remove('PersonalAccessToken') # remove the PersonalAccessToken
                $invokeParams # and return other parameters.
                continue
            }
            if (-not $PSCmdlet.ShouldProcess("Add AreaPath $AreaPath")) { continue } # Check ShouldProcess
            $typeName = "$Organization.AreaPath", "$Organization.$project.AreaPath", "PSDevOps.AreaPath"

            # Invoke the REST API.
            Invoke-ADORestAPI @invokeParams -PSTypeName $typeName -Property @{
                Organization = $organization
                Project = $Project
                Server = $server
            }
        }
        #endregion Until the Queue is Empty
        if ($t -gt 1) {
            Write-Progress "Adding Area Paths" ' ' -Completed -Id $id
        }
    }
}