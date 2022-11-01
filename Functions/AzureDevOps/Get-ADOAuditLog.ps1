function Get-ADOAuditLog {
<#
    .SYNOPSIS
        Gets the Azure DevOps Audit Log
    .DESCRIPTION
        Gets the Azure DevOps Audit Log for a Given Organization
    .EXAMPLE
        Get-ADOAuditLog
    .LINK
        https://docs.microsoft.com/en-us/rest/api/azure/devops/audit/audit-log/query
    
#>
    
    param(
# The Organization
[Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='https://auditservice.dev.azure.com/{Organization}/_apis/audit/auditlog')]
[string]
$Organization,
# The size of the batch of audit log entries.
    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $BatchSize,
# The start time.
    [Parameter(ValueFromPipelineByPropertyName)]
    [DateTime]
    $StartTime,
# The end time.
    [Parameter(ValueFromPipelineByPropertyName)]
    [DateTime]
    $EndTime,
# The api-version.  By default, 7.1-preview.1
    [Parameter(ValueFromPipelineByPropertyName)]    
    [ComponentModel.DefaultBindingProperty("api-version")]
    [string]
    $ApiVersion = '7.1-preview.1'
    )
    dynamicParam { . $GetInvokeParameters -DynamicParameter 
}
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        $invokeParams.ExpandProperty = 'decoratedAuditLogEntries'
        $invokeParams.PSTypeName    = "ADO.AuditLog.Entry"
        #endregion Copy Invoke-ADORestAPI parameters
    
    # Declare a Regular Expression to match URL variables. 
    $RestVariable = [Regex]::new(@'
# Matches URL segments and query strings containing variables.
# Variables can be enclosed in brackets or curly braces, or preceeded by a $ or :
(?>                           # A variable can be in a URL segment or subdomain
    (?<Start>[/\.])           # Match the <Start>ing slash|dot ...
    (?<IsOptional>\?)?        # ... an optional ? (to indicate optional) ...
    (?:
        \{(?<Variable>\w+)\}| # ... A <Variable> name in {} OR
        \[(?<Variable>\w+)\]| #     A <Variable> name in [] OR
        \<(?<Variable>\w+)\>| #     A <Variable> name in <> OR
        \:(?<Variable>\w+)    #     A : followed by a <Variable>
    )
|
    (?<IsOptional>            # If it's optional it can also be
        [{\[](?<Start>/)      # a bracket or brace, followed by a slash
    )
    (?<Variable>\w+)[}\]]     # then a <Variable> name followed by } or ]
|                             # OR it can be in a query parameter:
    (?<Start>[?&])            # Match The <Start>ing ? or & ...
    (?<Query>[\w\-]+)         # ... the <Query> parameter name ...
    =                         # ... an equals ...
    (?<IsOptional>\?)?        # ... an optional ? (to indicate optional) ...
    (?:
        \{(?<Variable>\w+)\}| # ... A <Variable> name in {} OR
        \[(?<Variable>\w+)\]| #     A <Variable> name in [] OR
        \<(?<Variable>\w+)\>| #     A <Variable> name in <> OR
        \:(?<Variable>\w+)    #     A : followed by a <Variable>
    )
)
'@, 'IgnoreCase,IgnorePatternWhitespace')
    
    # Next declare a script block that will replace the rest variable.
    $ReplaceRestVariable = {
        param($match)
        if ($uriParameter -and $uriParameter[$match.Groups["Variable"].Value]) {
            return $match.Groups["Start"].Value + $(
                    if ($match.Groups["Query"].Success) { $match.Groups["Query"].Value + '=' }
                ) +
                ([Web.HttpUtility]::UrlEncode(
                    $uriParameter[$match.Groups["Variable"].Value]
                ))
        } else {
            return ''
        }
    }
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
    $queryParameterNames = @('BatchSize','StartTime','EndTime','ApiVersion')
    $joinQueryValue      = ''
    $uriParameterNames   = @('Organization')
    $endpoints           = @("https://auditservice.dev.azure.com/{Organization}/_apis/audit/auditlog")
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
    $originalUri = "$psParameterSet"
    if (-not $PSBoundParameters.ContainsKey('UriParameter')) {
        $uriParameter = [Ordered]@{}
    }
    foreach ($uriParameterName in $uriParameterNames) {
        if ($psBoundParameters.ContainsKey($uriParameterName)) {
            $uriParameter[$uriParameterName] = $psBoundParameters[$uriParameterName]
        }
    }
    $uri = $RestVariable.Replace($originalUri, $ReplaceRestVariable)
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

