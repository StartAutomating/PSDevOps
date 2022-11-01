function Get-ADOServiceHealth {
    <#
    .SYNOPSIS
        Gets the Azure DevOps Service Health
    .DESCRIPTION
        Gets the Service Health of Azure DevOps.
    .EXAMPLE
        Get-ADOServiceHealth
    .EXAMPLE
        Get-ADOServiceHealth
    .LINK
        https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get        
    #>
    [Rest("https://status.dev.azure.com/_apis/status/health",
        Invoker='Invoke-ADORestAPI',
        UriParameterHelp={
            @{Organization = "The Organization"}
        },
        JoinQueryValue = ',',
        QueryParameter = {
# QueryParameter can be many types, including a [ScriptBlock].
# So in order to work as expected, we need to return a [ScriptBlock]
{
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
}
}
    )]
    param()

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        $invokeParams.PSTypeName    = "ADO.Service.Health"
        #endregion Copy Invoke-ADORestAPI parameters
    }
}

