Write-FormatView -TypeName PSDevOps -Property Name, ScriptType, Synopsis, Parameters -VirtualProperty @{        
    Parameters = {        
        @(foreach ($kv in ([Management.Automation.CommandMetaData]$_).Parameters.GetEnumerator()) {
            @(
            . $setOutputStyle -ForegroundColor Verbose 
            "[$($kv.Value.ParameterType)]"
            . $clearOutputStyle
            . $setOutputStyle -ForegroundColor Warning
            "`$$($kv.Key)"
            . $clearOutputStyle
            ) -join ''
        }) -join [Environment]::NewLine
    }
} -Wrap -ColorProperty @{
    "Name" = {"Success"}
}

Write-FormatView -TypeName PSDevOps -Property Name, Description -Width 30, 0 -Wrap -Name Description