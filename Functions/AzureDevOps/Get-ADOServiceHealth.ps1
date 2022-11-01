function Get-ADOServiceHealth {
<#
    .SYNOPSIS
        Gets the Azure DevOps Service Health
    .DESCRIPTION
        Gets the Service Health of Azure DevOps.
    .EXAMPLE
        Get-ADOServiceHealth
    .LINK
        https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get        
    
#>
    
    param(
# If provided, will query for health in a given geographic region.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("services")]
    [Alias('Services')]
    [ValidateSet('Artifacts', 'Boards', 'Core services', 'Other services', 'Pipelines', 'Repos', 'Test Plans')]
    [string[]]
    $Service,
# If provided, will query for health in a given geographic region.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("geographies")]
    [Alias('Geographies','Region', 'Regions')]
    [ValidateSet('APAC', 'AU', 'BR', 'CA', 'EU', 'IN', 'UK', 'US')]
    [string[]]
    $Geography,
# The api-version.  By default, 6.0
    [Parameter(ValueFromPipelineByPropertyName)]    
    [ComponentModel.DefaultBindingProperty("api-version")]
    [string]
    $ApiVersion = '6.0-preview'
    )
    dynamicParam { . $GetInvokeParameters -DynamicParameter 
}
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        $invokeParams.PSTypeName    = "ADO.Service.Health"
        #endregion Copy Invoke-ADORestAPI parameters
    
        $myCmd = $MyInvocation.MyCommand
        function ConvertRestInput {
                    param([Collections.IDictionary]$RestInput = @{}, [switch]$ToQueryString)
                    foreach ($ri in @($RestInput.GetEnumerator())) {
                        $RestParameterAttributes = @($myCmd.Parameters[$ri.Key].Attributes)
                        $restParameterName  = $ri.Key
                        $restParameterValue = $ri.Value
                        foreach ($attr in $RestParameterAttributes) {
                            if ($attr -is [ComponentModel.AmbientValueAttribute] -and 
                                $attr.Value -is [ScriptBlock]) {
                                $_ = $this = $ri.Value
                                $restParameterValue = & $attr.Value
                            }
                            if ($attr -is [ComponentModel.DefaultBindingPropertyAttribute]) {
                                $restParameterName = $attr.Name
                            }
                        }
                        $restParameterValue = 
                            if ($restParameterValue -is [DateTime]) {
                                $restParameterValue.Tostring('o')
                            }
                            elseif ($restParameterValue -is [switch]) {
                                $restParameterValue -as [bool]
                            }
                            else {
                                if ($ToQueryString -and 
                                    $restParameterValue -is [Array] -and 
                                    $JoinQueryValue) {
                                    $restParameterValue -join $JoinQueryValue
                                } else {
                                    $restParameterValue
                                }
                                
                            }
                        
                        if ($restParameterValue -is [Collections.IDictionary]) {
                            $RestInput.Remove($ri.Key)
                            foreach ($kv in $restParameterValue.GetEnumerator()) {
                                $RestInput[$kv.Key] = $kv.Value
                            }
                        } elseif ($restParameterName -ne $ri.Key) {
                            $RestInput.Remove($ri.Key)
                            $RestInput[$restParameterName] = $restParameterValue
                        } else {
                            $RestInput[$ri.Key] = $restParameterValue
                        }
                    }
                    $RestInput
                
        }
    
}
process {
    $InvokeCommand       = 'Invoke-ADORestAPI'
    $invokerCommandinfo  = 
        $ExecutionContext.SessionState.InvokeCommand.GetCommand('Invoke-ADORestAPI', 'All')
    $method              = ''
    $contentType         = ''
    $bodyParameterNames  = @('')
    $queryParameterNames = @('Service','Geography','ApiVersion')
    $joinQueryValue      = ','
    $uriParameterNames   = @('')
    $endpoints           = @("https://status.dev.azure.com/_apis/status/health")
    $ForEachOutput = {
        
    }
    if ($ForEachOutput -match '^\s{0,}$') {
        $ForEachOutput = $null
    }    
    if (-not $invokerCommandinfo) {
        Write-Error "Unable to find invoker '$InvokeCommand'"
        return        
    }
    if (-not $psParameterSet) { $psParameterSet = $psCmdlet.ParameterSetName}
    if ($psParameterSet -eq '__AllParameterSets') { $psParameterSet = $endpoints[0]}    
        $uri = $endpoints[0]
    
    $invokeSplat = @{}
    $invokeSplat.Uri = $uri
    if ($method) {
        $invokeSplat.Method = $method
    }
    if ($ContentType -and $invokerCommandInfo.Parameters.ContentType) {        
        $invokeSplat.ContentType = $ContentType
    }
    if ($InvokeParams -and $InvokeParams -is [Collections.IDictionary]) {
        $invokeSplat += $InvokeParams
    }
    $QueryParams = [Ordered]@{}
    foreach ($QueryParameterName in $QueryParameterNames) {
        if ($PSBoundParameters.ContainsKey($QueryParameterName)) {
            $QueryParams[$QueryParameterName] = $PSBoundParameters[$QueryParameterName]            
        } else {
            $queryDefault = $ExecutionContext.SessionState.PSVariable.Get($QueryParameterName).Value
            if ($null -ne $queryDefault) {
                $QueryParams[$QueryParameterName] = $queryDefault
            }
        }
    }
    $queryParams = ConvertRestInput $queryParams -ToQueryString
    if ($invokerCommandinfo.Parameters['QueryParameter'] -and 
        $invokerCommandinfo.Parameters['QueryParameter'].ParameterType -eq [Collections.IDictionary]) {
        $invokeSplat.QueryParameter = $QueryParams
    } else {
        $queryParamStr = 
            @(foreach ($qp in $QueryParams.GetEnumerator()) {
                $qpValue = $qp.value                
                if ($JoinQueryValue -eq '&') {
                    foreach ($qVal in $qpValue -split '&') {
                        "$($qp.Key)=$([Web.HttpUtility]::UrlEncode($qValue).Replace('+', '%20'))"    
                    }
                } else {
                    "$($qp.Key)=$([Web.HttpUtility]::UrlEncode($qpValue).Replace('+', '%20'))"
                }
            }) -join '&'
        if ($invokeSplat.Uri.Contains('?')) {
            $invokeSplat.Uri = "$($invokeSplat.Uri)" + '&' + $queryParamStr
        } else {
            $invokeSplat.Uri = "$($invokeSplat.Uri)" + '?' + $queryParamStr
        }
    }
    Write-Verbose "$($invokeSplat.Uri)"
    if ($ForEachOutput) {
        if ($ForEachOutput.Ast.ProcessBlock) {
            & $invokerCommandinfo @invokeSplat | & $ForEachOutput
        } else {
            & $invokerCommandinfo @invokeSplat | ForEach-Object -Process $ForEachOutput
        }        
    } else {
        & $invokerCommandinfo @invokeSplat
    }
}
}


