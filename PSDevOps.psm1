[Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ModuleManifestQuality*", "", Justification="FileList is unimportant")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForSlowScript", "", Justification="Performance is not a priority for this module")]
param()
#region Import Functions
foreach ($file in Get-ChildItem -Path $psScriptRoot -Filter *-*.ps1) {
    . $file.FullName
}
#endregion Import Functions

Add-Type -AssemblyName System.Web # Add System.Web now, in the unlikely event it was not already loaded.

#region Import Parts

# Parts are simple .ps1 files beneath a /Parts directory that can be used throughout the module.
$partsDirectory = $( # Because we want to be case-insensitive, and because it's fast
    foreach ($dir in [IO.Directory]::GetDirectories($psScriptRoot)) { # [IO.Directory]::GetDirectories()
        if ($dir -imatch "\$([IO.Path]::DirectorySeparatorChar)Parts$") { # and some Regex
            [IO.DirectoryInfo]$dir;break # to find our parts directory.
        }
    })

if ($partsDirectory) { # If we have parts directory
    foreach ($partFile in $partsDirectory.EnumerateFileSystemInfos()) { # enumerate all of the files.
        if ($partFile.Extension -ne '.ps1') { continue } # Skip anything that's not a PowerShell script.
        $partName = # Get the name of the script.
            $partFile.Name.Substring(0, $partFile.Name.Length - $partFile.Extension.Length)
        $ExecutionContext.SessionState.PSVariable.Set( # Set a variable
            $partName, # named the script that points to the script (e.g. $foo = gcm .\Parts\foo.ps1)
            $ExecutionContext.SessionState.InvokeCommand.GetCommand($partFile.Fullname, 'ExternalScript')
        )
    }
}
#endregion Import Parts

#region Load Extension Modules
$extensionModules =
    @(
        $myInvocation.MyCommand.ScriptBlock.Module
        . $GetExtensionModule $MyInvocation.MyCommand.ScriptBlock.Module.Name
    )
#endregion Load Extension Modules

#region Import Components
$extensionModules |
    Import-BuildStep
#endregion Import Components

$myInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Disconnect-ADO
}