function Add-ADOIterationPath
{
    <#
    .Synopsis
        Adds an Azure DevOps IterationPath
    .Description
        Adds an Azure DevOps IterationPath.  IterationPaths are used to logically group work items within a project.
    .Example
        Add-ADOIterationPath -Organization MyOrg -Project MyProject -IterationPath MyIterationPath
    .Example
        Add-ADOIterationPath -Organization MyOrg -Project MyProject -IterationPath MyIterationPath\MyNestedPath
    .Link
        Get-ADOIterationPath
    .Link
        Remove-ADOIterationPath
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('PSDevOps.IterationPath')]
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

    # The IterationPath.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $IterationPath,

    # The start date of the iteration.
    [Parameter(ValueFromPipelineByPropertyName)]
    [DateTime]
    $StartDate,

    # The end date of the iteration.
    [Parameter(ValueFromPipelineByPropertyName)]
    [DateTime]
    $EndDate,

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
        $allIterationPaths = @{}
        #region Until the Queue is Empty
        while ($q.Count) {
            $qi = $q.Dequeue() # Dequeue each item.
            $getIterationPathParams = @{} + $qi # Prepare input for Get-ADOIterationPath
            $getIterationPathParams.Remove('IterationPath')
            $getIterationPathParams.Remove('StartDate')
            $getIterationPathParams.Remove('EndDate')
            $getIterationPathParams.Remove('WhatIf')
            $getIterationPathParams.Remove('Confirm')
            foreach ($kv in $qi.GetEnumerator()) { # Repopulate the input parameters.
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }
            if ($t -gt 1) {
                $c++
                Write-Progress "Adding Iteration Paths" "$IterationPath " -PercentComplete ($c * 100 / $t) -Id $id
            }
            $IterationPathParts= @($IterationPath -split '\\')
            if (-not $allIterationPaths["$Organization/$Project"]) { # Cache ADO Iteration Paths
                $allIterationPaths["$Organization/$Project"] = @(Get-ADOIterationPath @getIterationPathParams)
            }

            $existingIterationPath = $null
            $closestIterationPath  = $null
            $IterationPathCache    = $allIterationPaths["$Organization/$Project"]
            foreach ($path in $IterationPathCache) { # See If the path already exists, or where we can put it in the hierarchy.
                if ($path.Path -eq "\$project\Iteration\$IterationPath") {
                    $existingIterationPath = $path
                }
                elseif ($IterationPathParts.Count -gt 1) {
                    for ($i = ($IterationPathParts.Count - 2); $i -ge 0; $i--) {
                        if ($path.Path -like "\$Project\Iteration\$($IterationPathParts[0..$i] -join '\')") {
                            $closestIterationPath = $path.Path
                            break
                        }
                    }
                }
            }

            if ($existingIterationPath) { # If it already existed, write it to Verbose.
                Write-Verbose "IterationPath: '\$Project\Iteration\$IterationPath' already exists"
                continue
            }

            $body = @{name = $IterationPathParts[-1]} # Prepare the input body

            $base = "/{Organization}/{Project}/_apis/wit/classificationNodes/Iterations"
            if ($closestIterationPath) { # If we had a closest path,

                $firstSlash, $projectPart, $IterationPart, $closestPart = # split up the IterationPath
                    $closestIterationPath -split '\\', 4
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
            if ($StartDate -or $EndDate) {
                $body.attributes = @{}
            }
            if ($StartDate) { $body.Attributes.startDate  = $StartDate.ToUniversalTime().ToString('o') }
            if ($EndDate)   { $body.Attributes.finishDate = $EndDate.ToUniversalTime().ToString('o')   }

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'POST'
            $invokeParams.Body = $body

            if ($WhatIfPreference) { # If we passed -WhatIf
                $invokeParams.Remove('PersonalAccessToken') # remove the PersonalAccessToken
                $invokeParams # and return other parameters.
                continue
            }
            if (-not $PSCmdlet.ShouldProcess("Add IterationPath $IterationPath")) { continue } # Check ShouldProcess
            $typeName = "$Organization.IterationPath", "$Organization.$project.IterationPath", "PSDevOps.IterationPath"

            # Invoke the REST API.
            Invoke-ADORestAPI @invokeParams -PSTypeName $typeName -Property @{
                Organization = $organization
                Project = $Project
                Server = $server
            }
        }
        #endregion Until the Queue is Empty
        if ($t -gt 1) {
            Write-Progress "Adding Iteration Paths" ' ' -Completed -Id $id
        }
    }
}