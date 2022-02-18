function Convert-ADOPipeline
{
    <#
    .Synopsis
        Converts builds to Azure DevOps Pipelines
    .Description
        Converts builds TFS or "Classic" builds to Azure DevOps YAML Pipelines.
    .Link
        New-ADOPipeline
    .Link
        Get-ADOTask
    .Example
        $taskList = (Get-ADOTask -Server $tfsRootUrl -Org $projectCollectionName)
        Get-ADOBuild -Definition -Server $tfsRootUrl -Org $projectCollection |
            Convert-ADOPipeline -TaskList $taskList
    #>
    [OutputType([string],[PSObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidAssignmentToAutomaticVariable", "", Justification="Functionality is Desired")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusedVariable", "", Justification="Functionality is Desired")]
    param(
    # A list of build steps.
    # This will be automatically populated when piping in a TFS Build definition.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Build')]
    [PSObject[]]
    $BuildStep,

    # An object containing build variables.
    # This will be automatically populated when piping in a TFS build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Variable','Variables')]
    [PSObject]
    $BuildVariable,

    # A list of task definitions.  This will normally be the output from Get-ADOTask.
    [Parameter(Mandatory)]
    [PSObject[]]
    $TaskList,

    # A dictionary of conditional transformations.
    [Alias('WhereForeach','WhereFor')]
    [ValidateScript({
        foreach ($k in $_.Keys) {
            if ($k -isnot [string] -and $k -isnot [ScriptBlock]) {
                throw "Key must be a string or ScriptBlock"
            }
        }
        foreach ($v in $_.Values) {
            if ($v -isnot [ScriptBlock]) {
                throw "Values must be script blocks"
            }
        }
        return $true
    })]
    [Collections.IDictionary]
    $WhereFore,

    # If set, will output the dictionary used to create each pipeline.
    # If not set, will output the pipeline YAML.
    [switch]
    $Passthru
    )

    begin {
        $q = [Collections.Queue]::new()
    }

    process {
        #region Enqueue Input
        $in = $_

        if (-not $BuildStep.Task) {
            Write-Error "Build Step must contain tasks"
            return
        }
        $q.Enqueue(
            @{psParameterSet= $PSCmdlet.ParameterSetName;InputObject= $in} + $PSBoundParameters
        )
        #endregion Enqueue Input
    }

    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {

            $dequeued = $q.Dequeue()
            $BuildVariable = $null
            foreach ($kv in $dequeued.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }

            $C++
            Write-Progress "Converting Builds" "[$c of $t]" -PercentComplete ($c * 100 / $t) -Id $id

            $buildSteps =
                @(foreach ($bs in $BuildStep) {

                    $matchingTask = $TaskList |
                        Where-Object ID -eq $bs.task.id

                    if (-not $matchingTask) {
                        Write-Warning "Could not find task $($bs.task.id)"
                    } else {
                        $taskName=  $matchingTask | Select-Object -ExpandProperty Name -Unique
                        $newTask = [Ordered]@{
                            task = $taskName + '@' + ($bs.task.versionSpec -replace '\.\*')
                            inputs = [Ordered]@{}
                        }
                        foreach ($prop in $bs.inputs.psobject.properties) {
                            if (-not [String]::IsNullOrWhiteSpace($prop.Value)) {
                                $newTask.inputs[$prop.Name] = $prop.Value
                            }
                        }

                        if (-not $newTask.inputs.count) {
                            $newTask.Remove('inputs')
                        }

                        if (-not $WhereFore.Count) {
                            $newTask
                        } else {
                            :outputted do {
                                foreach ($wf in $WhereFore.GetEnumerator()) {
                                    $this = $_ = $newTask
                                    if (
                                        $wf.Key -is [string] -and $newTask.task -like $wf.Key -or
                                        $wf.Key -is [ScriptBlock] -and (. $wf.Key)
                                    ) {
                                        $this = $_ = $newTask
                                        . $wf.Value
                                        break outputted
                                    }
                                }
                                $newTask
                            } while ($false)
                        }
                    }
                })

            $buildVariables = @(
                if ($BuildVariable) {
                    foreach ($bv in $BuildVariable.psobject.properties) {
                        [Ordered]@{name=$bv.Name;value=$bv.value.value}
                    }
                }
            )

            if ($PassThru) {
                $out = ([Ordered]@{variables=$BuildVariables;steps=$buildSteps})
                if ($inputObject) {
                    Add-Member -InputObject $out -MemberType NoteProperty -Name InputObject -Value $inputObject -Force
                }
                $out
            } else {

                $newPipeline =
                    New-ADOPipeline -InputObject ([Ordered]@{variables=$BuildVariables;steps=$buildSteps})

                if ($inputObject) {
                    $newPipeline |
                        Add-Member NoteProperty InputObject $inputObject -Force
                }

                $newPipeline
            }
        }

        $C++
        Write-Progress "Converting Builds" "[$c of $t]" -Completed -Id $id
    }
}
