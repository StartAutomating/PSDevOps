﻿#requires -Module EZOut
# Install-Module EZOut or https://github.com/StartAutomating/EZOut
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="This generates format files (where its ok to Write-Host)")]
param()
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = $($myFile | Split-Path -Leaf) -replace '\.ezformat\.ps1', ''
$myRoot = $myFile | Split-Path


$formatting = @(
    Import-FormatView -FilePath (Join-Path $myRoot Formatting)
)

$myFormatFile = Join-Path $myRoot "$myModuleName.format.ps1xml"
$formatting | Out-FormatData -ModuleName PSDevOps | Set-Content $myFormatFile -Encoding UTF8

$types = @(
    <#
    Write-TypeView -TypeName PSDevOps.ArtifactFeed.View -AliasProperty @{
        ViewID = 'id'
    }
    Write-TypeView -TypeName PSDevOps.ArtifactFeed -AliasProperty @{
        FeedID = 'fullyQualifiedId'
    } -HideProperty ViewID
    Write-TypeView -TypeName PSDevOps.Build.Definition -AliasProperty @{
        DefinitionID = 'ID'
    }
    Write-TypeView -TypeName PSDevOps.Repository -AliasProperty @{
        RepositoryID = 'ID'
    }
    Write-TypeView -TypeName PSDevOps.ServiceEndpoint -AliasProperty @{
        EndpointID = 'ID'
        EndpointType = 'Type'
    }
    Write-TypeView -TypeName PSDevOps.Repository.SourceProvider -AliasProperty @{
        ProviderName = 'Name'
    }
    Write-TypeView -TypeName PSDevOps.Project -AliasProperty @{
        Project = 'Name'
        ProjectID = 'ID'
    } -ScriptProperty @{
        LastUpdated = {[DateTime]$this.LastUpdateTime}
    } -DefaultDisplay Organization, Project, LastUpdateTime, Description
    #>
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
        Import-TypeView -Deserialized

)

$myTypesFile = Join-Path $myRoot "$myModuleName.types.ps1xml"
$types | Out-TypeData | Set-Content $myTypesFile -Encoding UTF8