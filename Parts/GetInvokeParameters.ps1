<#
.Synopsis
    Gets Invoke-ADORestAPI's parameters
.Description
    Gets the parameters for Invoke-ADORestAPI from a collection of parameters
#>
param(
# A collection of parameters.  Parameters not used in Invoke-ADORestAPI will be removed
[Parameter(ValueFromPipeline,Position=0,Mandatory)]
[Alias('Parameters')]
[Collections.IDictionary]
$Parameter
)

begin {
    if (-not ${script:Invoke-RestApi}) { # If we haven't cached a reference to Invoke-ADORestAPI,
        ${script:Invoke-RestApi} = # make it so.
            [Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand('Invoke-ADORestAPI', 'Function')
    }
}

process {
    $invokeParams = [Ordered]@{} + $Parameter # Then we copy our parameters
    foreach ($k in @($invokeParams.Keys)) {  # and walk thru each parameter name.
        # If a parameter isn't found in Invoke-ADORestAPI
        if (-not ${script:Invoke-RestApi}.Parameters.ContainsKey($k)) {
            $invokeParams.Remove($k) # we remove it.
        }
    }
    return $invokeParams
}