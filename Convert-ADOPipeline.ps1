function Convert-ADOPipeline
{
    <#
    .Synopsis
        Converts builds to Azure DevOps Pipelines
    .Description
        Converts builds to Azure DevOps YAML Pipelines.
    #>
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
    [Alias('Variable')]
    [PSObject]
    $BuildVariable,

    # A list of task definitions.  This will normally be the output from Get-ADOTask.
    [Parameter(Mandatory)]
    [PSObject[]]
    $TaskList
    )

    begin {
        $q = [Collections.Queue]::new()

    }

    process {
        $in = $_


        if (-not $BuildStep.Task) {
            Write-Error "Build Step must contain tasks"
            return
        }
        $q.Enqueue(
            @{psParameterSet= $PSCmdlet.ParameterSetName;InputObject= $in} + $PSBoundParameters
        )
    }

    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {

            $dequeued = $q.Dequeue()
            $BuildVariable = $null
            foreach ($kv in $dequeued.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }

            if ($t -gt 1) {
                $C++
                Write-Progress "Converting Builds" "[$c of $t]" -PercentComplete ($c * 100 / $t) -Id $id
            }

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
                                $newTask[$prop.Name] = $prop.Value
                            }
                        }
                        $newTask
                    }
                })

            $buildVariables = @(
                if ($BuildVariable) {
                    foreach ($bv in $BuildVariable.psobject.properties) {
                        [Ordered]@{name=$bv.Name;value=$bv.value.value}
                    }
                }
            )

            $newPipeline =
                New-ADOPipeline -InputObject ([Ordered]@{variables=$BuildVariables;steps=$buildSteps})

            if ($inputObject) {
                $newPipeline |
                    Add-Member NoteProperty InputObject $inputObject -Force
            }

            $newPipeline
        }
    }
}
