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
    [Rest("https://auditservice.dev.azure.com/{Organization}/_apis/audit/auditlog",
        Invoker='Invoke-ADORestAPI',
        UriParameterHelp={
            @{Organization = "The Organization"}
        },
        QueryParameter = {
# QueryParameter can be many types, including a [ScriptBlock].
# So in order to work as expected, we need to return a [ScriptBlock]
{
    param(
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
}
}
    )]
    param()

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        $invokeParams.ExpandProperty = 'decoratedAuditLogEntries'
        $invokeParams.PSTypeName    = "ADO.AuditLog.Entry"
        #endregion Copy Invoke-ADORestAPI parameters
    }
}
