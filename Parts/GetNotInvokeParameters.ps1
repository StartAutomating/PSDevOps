<#
.Synopsis
    Gets parameters that are not Invoke-ADORestAPI's
.Description
    Gets the parameters that are not Invoke-ADORestAPI from a collection of parameters.
    Also blacklists a series of other parameters:  Right now, Organization, Project, and Server
#>
param(
# A collection of parameters.  Parameters not used in Invoke-ADORestAPI will be removed
[Parameter(ValueFromPipeline,Position=0,Mandatory)]
[Alias('Parameters')]
[Collections.IDictionary]
$Parameter,

[string[]]
$Blacklist = @('Organization', 'Project', 'Server')
)

begin {
    if (-not ${script:Invoke-RestApi}) { # If we haven't cached a reference to Invoke-ADORestAPI,
        ${script:Invoke-RestApi} = # make it so.
            [Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand('Invoke-ADORestAPI', 'Function')
    }
}

process {
    $notInvokeParams = [Ordered]@{} + $Parameter # Then we copy our parameters
    foreach ($k in @($notInvokeParams.Keys)) {  # and walk thru each parameter name.
        # If a parameter is found in Invoke-ADORestAPI
        if (${script:Invoke-RestApi}.Parameters.ContainsKey($k)) {
            $notInvokeParams.Remove($k) # we remove it.
        }
        if ($blackList -contains $k) { # If it's in the blacklist
            $notInvokeParams.Remove($k) # we remove it.
        }
    }
    return $notInvokeParams
}