function Get-ADOWorkItemType
{
    <#
    .Synopsis
        Gets work item types
    .Description
        Gets work item types from Azure DevOps
    .Example
        Get-ADOWorkProcess -Organization StartAutomating -Project PSDevOps |
            Get-ADOWorkItemType
    .Example
        Get-ADOWorkItemType -Organization StartAutomating -Icon
    .Example
        Get-ADOWorkItemType -Organization StartAutomating -Project PSDevOps
    .Link
        Get-ADOWorkProcess
    #>
    [OutputType('PSDevOps.WorkItemType',
        'PSDevOps.State',
        'PSDevOps.Rule',
        'PSDevOps.Behavior',
        'PSDevOps.Layout')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired")]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The ProcessID.  This is returned from Get-ADOWorkProcess.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/layout')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors')]
    [Alias('TypeID')]
    [string]
    $ProcessID,

    # The Reference Name of the Work Item Type.  This can be provided by piping Get-ADOWorkItemType to itself.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/layout')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors')]
    [string]
    $ReferenceName,

    # If set, will get the layout associated with a given work item type.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/layout')]
    [switch]
    $Layout,

    # If set, will get the pages within a given work item type layout.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/layout')]
    [Alias('Pages')]
    [switch]
    $Page,


    # If set, will get the states associated with a given work item type.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/states')]
    [Alias('States')]
    [switch]
    $State,

    # If set, will get the rules associated with a given work item type.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Alias('Rules')]
    [switch]
    $Rule,

    # If set, will get the behaviors associated with a given work item type.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors')]
    [Alias('Behaviors')]
    [switch]
    $Behavior,

    # The name of the project.  If provided, will get work item type information related to the project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/{Project}/_apis/wit/workitemtypes')]
    [string]
    $Project,

    # If set, will get work item icons available to the organization.
    [Parameter(Mandatory,
        ParameterSetName='/{Organization}/_apis/wit/workitemicons')]
    [Alias('Icons')]
    [switch]
    $Icon,

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
        $q = [Collections.Queue]::new()
    }

    process {
        $in = $_
        $psParameterSet = $PSCmdlet.ParameterSetName
        if ($in.TypeID -and $ReferenceName) { # If we're piping in a work process, clear reference name
            $psBoundParameters['ReferenceName'] = $ReferenceName = ''

            $psParameterSet = $MyInvocation.MyCommand.Parameters['ProcessID'].ParameterSets.Keys |
                Sort-Object Length |
                Select-Object -First 1
        }
        $q.Enqueue(@{psParameterSet = $psParameterSet}+ $psBoundParameters)
    }

    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q
            $uri =
                "$Server".TrimEnd('/') +
                    (. $ReplaceRouteParameter $psParameterSet) +
                        '?'

            if ($Server -ne 'https://dev.azure.com/' -and
                    -not $psBoundParameters['apiVersion']) {
                $ApiVersion = '2.0'
            }

            $uri +=
                @(
                    if ($ApiVersion) {
                        "api-version=$ApiVersion"
                    }
                ) -join '&'

            $typeName = @($psParameterSet -split '/')[-1].ToString().TrimEnd('s')
            $typeNames = @(
                "$Organization.$typename"
                if ($Project) { "$Organization.$Project.$typeName" }
                "PSDevOps.$typeName"
            )

            if ($t -gt 1) {
                $c++
                Write-Progress "Getting $(@($psParameterSet -split '/')[-1])" "[$c / $t]" -PercentComplete ($c*  100 /$t) -Id $progId
            }

            $AddProperty = @{Organization=$Organization}
            if ($ProcessID) {
                $AddProperty['ProcessID'] = $ProcessID
            }
            if ($ReferenceName) {
                $AddProperty['ReferenceName'] = $ReferenceName
            }
            if ($Project) {
                $AddProperty['Project'] = $Project
            }
            if ($Page) {
                $invokeParams.ExpandProperty = 'pages'
            }

            $restResponse = Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName $typeNames -Property $AddProperty

            if ($restResponse -is [string]) {
                $restResponse =
                    $restResponse -replace '"":', '"_blank":' |
                        ConvertFrom-Json |
                            Select-Object -ExpandProperty Value |
                                & { process {
                                    $in = $_
                                    $in.pstypenames.clear()
                                    foreach ($tn in $typeNames) {
                                        $in.pstypenames.add($tn)
                                    }
                                    foreach ($ap in $AddProperty.GetEnumerator()) {
                                        $in | Add-Member NoteProperty $ap.Key $ap.Value -Force
                                    }
                                    $in
                                } }
            }

            $restResponse
        }

        if ($t -gt 1) {
            $c++
            Write-Progress "Getting $typeName" "[$c / $t]" -Completed -Id $progId
        }
    }

}
