<#
.Synopsis
    Gets Invoke-ADORestAPI's parameters
.Description
    Gets the parameters for Invoke-ADORestAPI from a collection of parameters
#>
param(
# A collection of parameters.  Parameters not used in Invoke-ADORestAPI will be removed
[Parameter(ValueFromPipeline,Position=0,Mandatory,ParameterSetName='GetParameterValues')]
[Alias('InvokeParameters')]
[Collections.IDictionary]
$InvokeParameter,

[Parameter(Mandatory,ParameterSetName='GetDynamicParameters')]
[Alias('DynamicParameters')]
[switch]
$DynamicParameter,

[Parameter(ParameterSetName='GetDynamicParameters')]
[string]
$CommandName
)

begin {
    if (-not ${script:Invoke-RestApi}) { # If we haven't cached a reference to Invoke-ADORestAPI,
        ${script:Invoke-RestApi} = # make it so.
            [Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand('Invoke-ADORestAPI', 'Function')
    }
}

process {
    if ($PSCmdlet.ParameterSetName -eq 'GetDynamicParameters') {
        if (-not $script:InvokeADORestAPIParams) {
            $script:InvokeADORestAPIParams = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $InvokeADORestApi = $executionContext.SessionState.InvokeCommand.GetCommand('Invoke-ADORestApi', 'All')
            :nextInputParameter foreach ($in in ([Management.Automation.CommandMetaData]$InvokeADORestApi).Parameters.Keys) {
                foreach ($ex in 'Uri','Method','Headers','Body','ContentType','ExpandProperty','Property','RemoveProperty','DecorateProperty','PSTypeName', 'ContinuationToken',
                    'UrlParameter','DynamicParameter','MapParameter', 'QueryParameter', 'AsByte') {
                    if ($in -like $ex) { continue nextInputParameter }
                }

                $script:InvokeADORestAPIParams.Add($in, [Management.Automation.RuntimeDefinedParameter]::new(
                    $InvokeADORestApi.Parameters[$in].Name,
                    $InvokeADORestApi.Parameters[$in].ParameterType,
                    $InvokeADORestApi.Parameters[$in].Attributes
                ))
            }
            foreach ($paramName in $script:InvokeADORestAPIParams.Keys) {
                foreach ($attr in $script:InvokeADORestAPIParams[$paramName].Attributes) {
                     if ($attr.ValueFromPipeline) {$attr.ValueFromPipeline = $false}
                     if ($attr.ValueFromPipelineByPropertyName) {$attr.ValueFromPipelineByPropertyName = $false}
                }
            }
        }        
        if (-not $CommandName) {
            return $script:InvokeADORestAPIParams
        }
        $extensionDynamicParameters = Get-PSDevOpsExtension -CommandName $CommandName -DynamicParameter
        if (-not $extensionDynamicParameters.Count) { return $script:InvokeADORestAPIParams }
        foreach ($dp in $script:InvokeADORestAPIParams.GetEnumerator()) {
            if (-not $extensionDynamicParameters[$dp.Key]) {
                $extensionDynamicParameters[$dp.Key] = $dp.value
            }
        }
        return $extensionDynamicParameters
    }
    if ($PSCmdlet.ParameterSetName -eq 'GetParameterValues') {
        $invokeParams = [Ordered]@{} + $InvokeParameter # Then we copy our parameters
        foreach ($k in @($invokeParams.Keys)) {  # and walk thru each parameter name.
            # If a parameter isn't found in Invoke-ADORestAPI
            if (-not ${script:Invoke-RestApi}.Parameters.ContainsKey($k)) {
                $invokeParams.Remove($k) # we remove it.
            }
        }
        if ($invokeParams.PersonalAccessToken) {
            $Script:CachedPersonalAccessToken = $invokeParams.PersonalAccessToken
        }
        if (-not $invokeParams.PersonalAccessToken -and $Script:CachedPersonalAccessToken) {
            $invokeParams.PersonalAccessToken = $Script:CachedPersonalAccessToken
        }
        if ($invokeParams.Credential) {
            $script:CachedCredential = $invokeParams.Credential
        }
        if (-not $invokeParams.Credential -and $script:CachedCredential) {
            $invokeParams.Credential = $script:CachedCredential
        }

        return $invokeParams
    }

}