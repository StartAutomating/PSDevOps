<#
.SYNOPSIS
    Initializes a container during build.
.DESCRIPTION
    Initializes the container image with the necessary modules and packages.

    This script should be called from the Dockerfile, during the creation of the container image.

    ~~~Dockerfile
    # Thank you Microsoft!  Thank you PowerShell!  Thank you Docker!
    FROM mcr.microsoft.com/powershell
    # Set the shell to PowerShell (thanks again, Docker!)
    SHELL ["/bin/pwsh", "-nologo", "-command"]
    # Run the initialization script.  This will do all remaining initialization in a single layer.
    RUN --mount=type=bind,src=./,target=/Initialize ./Initialize/Container.init.ps1
    ~~~
    
    The scripts arguments can be provided with either an `ARG` or `ENV` instruction in the Dockerfile.
.NOTES
    Did you know that in PowerShell you can 'use' namespaces that do not really exist?
    This seems like a nice way to describe a relationship to a container image.
    That is why this file is using the namespace 'mcr.microsoft.com/powershell'.
    (this does nothing, but most likely will be used in the future)
#>
using namespace 'mcr.microsoft.com/powershell'

param(
# The name of the module to be installed.
[string]$ModuleName = $(
    if ($env:ModuleName) { $env:ModuleName }
    else { 
        (Get-ChildItem -Path $PSScriptRoot | 
        Where-Object Extension -eq '.psd1' | 
        Select-String 'ModuleVersion\s=' | 
        Select-Object -ExpandProperty Path -First 1) -replace '\.psd1$'
    }      
),
# The packages to be installed.
[string[]]$InstallPackages = @(
    if ($env:InstallPackages) { $env:InstallPackages -split ',' }
    else { }
),
# The modules to be installed.
[string[]]$InstallModules = @(
    if ($env:InstallModules) { $env:InstallModules -split ',' }    
    else {  }
)
)


# Get the root module directory
$rootModuleDirectory = @($env:PSModulePath -split '[;:]')[0]

# Determine the path to the module destination. 
$moduleDestination = "$rootModuleDirectory/$ModuleName"
# Copy the module to the destination
# (this is being used instead of the COPY statement in Docker, to avoid additional layers).
Copy-Item -Path "$psScriptRoot" -Destination $moduleDestination -Recurse -Force

# Copy all container-related scripts to the root of the container.
Get-ChildItem -Path $PSScriptRoot | 
    Where-Object Name -Match '^Container\..+?\.ps1$' | 
    Copy-Item -Destination /

# If we have packages to install
if ($InstallPackages) {
    # install the packages
    apt-get update && apt-get install -y @InstallPackages && apt-get clean | Out-Host
}

# Create a new profile
New-Item -Path $Profile -ItemType File -Force |
    # and import this module in the profile
    Add-Content -Value "Import-Module $ModuleName" -Force
# If we have modules to install
if ($InstallModules) { 
    # Install the modules
    Install-Module -Name $InstallModules -Force -AcceptLicense -Scope CurrentUser 
    # and import them in the profile
    Add-Content -Path $Profile -Value "Import-Module '$($InstallModules -join "','")'" -Force
}
# In our profile, push into the module's directory
Add-Content -Path $Profile -Value "Get-Module $ModuleName | Split-Path | Push-Location" -Force

# Remove the .git directories from any modules
Get-ChildItem -Path $rootModuleDirectory -Directory -Force -Recurse |
    Where-Object Name -eq '.git' |
    Remove-Item -Recurse -Force

# Congratulations! You have successfully initialized the container image.
# This script should work in about any module, with minor adjustments.
# If you have any adjustments, please put them below here, in the `#region Custom`

#region Custom
#endregion Custom