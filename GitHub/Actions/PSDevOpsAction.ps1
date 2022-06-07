<#
.Synopsis
    GitHub Action for PSDevOps
.Description
    GitHub Action for PSDevOps.  This will:

    * Import PSDevOps and Connect-GitHub (giving easy access to every GitHub API)
    * Run all *.PSDevOps.ps1 files beneath the workflow directory
    * Run a .PSDevOpsScript parameter.


    If you will be making changes using the GitHubAPI, you should provide a -GitHubToken
    If none is provided, and ENV:GITHUB_TOKEN is set, this will be used instead.
    Any files changed can be outputted by the script, and those changes can be checked back into the repo.
    Make sure to use the "persistCredentials" option with checkout.

#>

param(
# A PowerShell Script that uses PSDevOps.  
# Any files outputted from the script will be added to the repository.
# If those files have a .Message attached to them, they will be committed with that message.
[string]
$PSDevOpsScript,

# If set, will not process any files named *.PSDevOps.ps1
[switch]
$SkipPSDevOpsPS1,

# If provided, will use this GitHubToken when running Connect-GitHub
[string]
$GitHubToken,

[PSObject]
$Parameter,

# If provided, will commit any remaining changes made to the workspace with this commit message.
[string]
$CommitMessage,

# The user email associated with a git commit.
[string]
$UserEmail,

# The user name associated with a git commit.
[string]
$UserName
)

"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

if ($env:GITHUB_ACTION_PATH) {
    $PSDevOpsModulePath = Join-Path $env:GITHUB_ACTION_PATH 'PSDevOps.psd1'
    if (Test-path $PSDevOpsModulePath) {
        Import-Module $PSDevOpsModulePath -Force -PassThru | Out-String
    } else {
        throw "PSDevOps not found"
    }
} elseif (-not (Get-Module PSDevOps)) {    
    throw "Action Path not found"
}

"::notice title=ModuleLoaded::PSDevOps Loaded from Path - $($PSDevOpsModulePath)" | Out-Host


$ght = 
    if ($GitHubToken) {
        $GitHubToken
    } elseif ($env:GITHUB_TOKEN) {
        $env:GITHUB_TOKEN
    }
"::group::Connecting to Github" | Out-Host
$connectStart = [DateTime]::now
Connect-GitHub -PersonalAccessToken $GitHubToken -PassThru | 
    ForEach-Object { 
        $githubModule = $_
        "::notice title=Connected::Connect-GitHub finished - $($githubModule.ExportedCommands.Count) Commands Imported" | Out-Host
        $githubModule.ExportedCommands.Keys -join [Environment]::Newline | Out-Host        
    } | 
    Out-Host
"::endgroup::" | Out-Host

$anyFilesChanged = $false
$processScriptOutput = { process { 
    $out = $_
    $outItem = Get-Item -Path $out -ErrorAction SilentlyContinue
    $fullName, $shouldCommit = 
        if ($out -is [IO.FileInfo]) {
            $out.FullName, (git status $out.Fullname -s)
        } elseif ($outItem) {
            $outItem.FullName, (git status $outItem.Fullname -s)
        }
    if ($shouldCommit) {
        git add $fullName
        if ($out.Message) {
            git commit -m "$($out.Message)"
        } elseif ($out.CommitMessage) {
            git commit -m "$($out.CommitMessage)"
        }
        $anyFilesChanged = $true
    }
    $out
} }


if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
if (-not $UserEmail) { $UserEmail = "$UserName@github.com" }
git config --global user.email $UserEmail
git config --global user.name  $UserName

if (-not $env:GITHUB_WORKSPACE) { throw "No GitHub workspace" }

git pull | Out-Host

$PSDevOpsScriptStart = [DateTime]::Now
if ($PSDevOpsScript) {
    Invoke-Expression -Command $PSDevOpsScript |
        . $processScriptOutput |
        Out-Host
}
$PSDevOpsScriptTook = [Datetime]::Now - $PSDevOpsScriptStart
"::set-output name=PSDevOpsScriptRuntime::$($PSDevOpsScriptTook.TotalMilliseconds)"   | Out-Host

$PSDevOpsPS1Start = [DateTime]::Now
$PSDevOpsPS1List  = @()
if (-not $SkipPSDevOpsPS1) {
    Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE |
        Where-Object Name -Match '\.PSDevOps\.ps1$' |
        
        ForEach-Object {
            $PSDevOpsPS1List += $_.FullName.Replace($env:GITHUB_WORKSPACE, '').TrimStart('/')
            $PSDevOpsPS1Count++
            "::notice title=Running::$($_.Fullname)" | Out-Host
            . $_.FullName |            
                . $processScriptOutput  | 
                Out-Host
        }
}
$PSDevOpsPS1EndStart = [DateTime]::Now
$PSDevOpsPS1Took = [Datetime]::Now - $PSDevOpsPS1Start
"::set-output name=PSDevOpsPS1Count::$($PSDevOpsPS1List.Length)"   | Out-Host
"::set-output name=PSDevOpsPS1Files::$($PSDevOpsPS1List -join ';')"   | Out-Host
"::set-output name=PSDevOpsPS1Runtime::$($PSDevOpsPS1Took.TotalMilliseconds)"   | Out-Host
if ($CommitMessage -or $anyFilesChanged) {
    if ($CommitMessage) {
        dir $env:GITHUB_WORKSPACE -Recurse |
            ForEach-Object {
                $gitStatusOutput = git status $_.Fullname -s
                if ($gitStatusOutput) {
                    git add $_.Fullname
                }
            }

        git commit -m $ExecutionContext.SessionState.InvokeCommand.ExpandString($CommitMessage)
    }

    
    

    $checkDetached = git symbolic-ref -q HEAD
    if (-not $LASTEXITCODE) {
        "::notice::Pushing Changes" | Out-Host
        $gitPushed = git push
        "Git Push Output: $($gitPushed  | Out-String)"
    } else {
        "::notice::Not pushing changes (on detached head)" | Out-Host
        $LASTEXITCODE = 0
        exit 0
    }
}
