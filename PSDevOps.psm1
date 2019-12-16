# First, import all *-*.ps1 files from the module's root directory.
foreach ($file in Get-ChildItem -Path $psScriptRoot -Filter *-*.ps1) {
    . $file.FullName
}


$partsDirectory = $(
    foreach ($dir in [IO.Directory]::GetDirectories($psScriptRoot)) {
        if ($dir -match "\$([IO.Path]::DirectorySeparatorChar)Parts$") {[IO.DirectoryInfo]$dir;break}
    })

if ($partsDirectory) {
    foreach ($partFile in $partsDirectory.EnumerateFileSystemInfos()) {
        if ($partFile.Extension -ne '.ps1') { continue } 
        $partName = $partFile.Name.Substring(0, $partFile.Name.Length - $partFile.Extension.Length)
        $ExecutionContext.SessionState.PSVariable.Set(
            $partName,
            $ExecutionContext.SessionState.InvokeCommand.GetCommand($partFile.Fullname, 'ExternalScript')
        )
    }
}

$extensionModules = 
    @(
        $myInvocation.MyCommand.ScriptBlock.Module
        . $GetExtensionModule $MyInvocation.MyCommand.ScriptBlock.Module.Name
    ) 

$extensionModules | 
    . $importComponents -ComponentRoot 'ado', 'githubactions'
