<#
.Synopsis
    Flushes the Request Queue
.Description
    Flushes the Queue of pending Invoke-ADORestApi calls.
#>
param(
# The name of the invoker command
[Parameter(Mandatory)]
[ValidateSet('Invoke-ADORestAPI','Invoke-GitHubRESTApi')]
[string]
$Invoker
)
if ((-not $t) -or (-not $progId)) {
    $c, $t, $progId = 0, $rq.Count, $(Get-Random)
}

while ($rq.Count) {
    $invokeSplat = $rq.Dequeue()

    if ($invokeParams) {
        $invokeSplat += $invokeParams
    }
    $invokeSplatUrl = $invokeSplat.Url, $invokeSplat.uri -ne $null
    if ("$invokeSplatUrl".StartsWith('/')) {
        $invokeSplatUrl = 
            @(
            "$server".TrimEnd('/')  # * The Server
            "/$organization"
            $invokeSplatUrl
            ) -join ''
        $invokeSplat.Remove('Url')
        $invokeSplat.Remove('Uri')                
        $invokeSplat.Url = $invokeSplatUrl
    }
    if ($ApiVersion -and -not $invokeSplat.QueryParameter.apiVersion) {
        if (-not $invokeSplat.QueryParameter) {
            $invokeSplat.QueryParameter = @{}
        }
        $invokeSplat.QueryParameter.'api-version' = $ApiVersion
    }

    $status = 
        if ($invokeSplat.Status) {
            $invokeSplat.Status
            $invokeSplat.Remove('Status')
        }
        elseif ($invokeSplat.Method) {
            $invokeSplat.Method
        } else 
        {
            "GET"
        }

    $activity =
        if ($invokeSplat.Activity) {
            $invokeSplat.Activity
            $invokeSplat.Remove('Activity')
        }
        elseif ($invokeSplatUrl) {
            $invokeSplatUrl
        } else
        {
            " "
        }

    if (-not $InvokeSplat.Property) {
        $InvokeSplat.Property = [Ordered]@{}
    }
    if ($organization -and -not $InvokeSplat.Property.Organization) {
        $InvokeSplat.Property.Organization = $organization
    }
    if ($ProjectID -and -not $InvokeSplat.Property.Organization) {
        $InvokeSplat.Property.ProjectID = $ProjectID
    }
    $c++
    $p = $c* 100/$t
    Write-Progress $status $activity -PercentComplete $p -Id $progId
    & $ExecutionContext.SessionState.InvokeCommand.GetCommand($Invoker, 'Function') @invokeSplat    
}
if ($c -eq $t) {
    Write-Progress $status $activity -Completed $progId
}