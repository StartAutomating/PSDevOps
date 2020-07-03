@{
    job = 'ScriptCop'
    displayName = 'ScriptCop'
    pool=@{
        vmImage= 'windows-latest'
    }
    steps = @('InstallPSDevOps','InstallScriptCop','RunScriptCop')
}

