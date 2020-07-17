param(
    [string]
    $TestOrg = 'StartAutomating',
    [string]
    $TestProject = 'PSDevOps'
)

Write-Verbose "Testing with $testOrg/$TestProject"

$testPat =
    if ($PersonalAccessToken) { $PersonalAccessToken }
    else { $env:SYSTEM_ACCESSTOKEN }


if (-not $testPat) { throw "Must have a PersonalAccessToken to test" }

describe 'Making Azure DevOps Output Look Nicer' {
    it 'Can Write an Azure DevOps Error' {
        Write-ADOError -Message "error!" -Debug |
        should match '\#\#vso\[task\.logissue type=error\]error!'
    }

    it 'Can Write an Azure DevOps Error with a SourcePath' {
        Write-ADOError -Message 'error!' -SourcePath file.cs -LineNumber 1 -Debug |
        should be '##vso[task.logissue type=error;sourcepath=file.cs;linenumber=1]error!'
    }

    it 'Can Write an Azure DevOps Warning' {
        Write-ADOWarning -Message "warning!" -Debug |
        should match '\#\#vso\[task\.logissue type=warning\]warning!'
    }

    it 'Can Write an Azure DevOps Warning with a SourcePath' {
        Write-ADOWarning -Message 'warning!' -SourcePath file.cs -LineNumber 1 -Debug |
        should be '##vso[task.logissue type=warning;sourcepath=file.cs;linenumber=1]warning!'
    }

    it 'Can set an Azure DevOps variable' {
        Set-ADOVariable -Name MyVar -Value MyValue -Debug |
        should match '\#\#vso\[task\.setvariable variable=MyVar\]MyValue'
    }
    it 'Can set an Azure DevOps variable that -IsSecret' {
        Set-ADOVariable -Name MySecret -Value IsSafe -IsSecret -Debug |
        should match '\#\#vso\[task\.setvariable variable=MySecret;issecret=true\]IsSafe'
    }

    it 'Can Write progress to the timeline' {
        $id = [Random]::new().Next()
        $nestedId = [Random]::new().Next()
        $p = 10
        Write-ADOProgress -Id $id -Activity 'Doing Stuff' -Status 'And Things' -PercentComplete $p -Debug |
        should belike '##vso?task.logdetail*'
        $p += 10

        Write-ADOProgress -Id $nestedId -ParentId $id -Activity 'Nested Stuff' -Status 'And Things' -PercentComplete $p -Debug |
        should belike '##vso?task.logdetail*parentid*'

        Write-ADOProgress -Id $id -Activity 'Doing Stuff' -Status 'Done' -Completed -Debug |
        should belike '##vso?task.logdetail*completed*'

        Write-ADOProgress -Activity 'Doing Stuff' -Status 'And Things' -SecondsRemaining 10 -Debug |
        should belike '*(10s*'

        Write-ADOProgress -Activity 'Doing Stuff' -Status 'And Things' -Id ([Random]::new().Next()) -CurrentOperation 'Working on a Thing' -Debug |
        should belike '*(Working on a Thing)*'
    }
}

describe 'Making Attachments Easier' {
    it 'Can add a summary file' {

        Add-ADOAttachment -Path blah.md -IsSummary -Debug |
        should be '##vso[task.uploadsummary]blah.md'
    }

    it 'Can attach an artifact' {
        Add-ADOAttachment -Path artifact.zip -ContainerFolder artifacts -ArtifactName myArtifact -Debug |
        should be "##vso[artifact.upload containerfolder=artifacts;artifactname=myArtifact]artifact.zip"

    }

    it 'Can attach any old file' {
        Add-ADOAttachment -Path myUpload.zip -Debug |
        should be '##vso[task.uploadfile]myUpload.zip'
    }

    it 'Can attach a log file' {
        Add-ADOAttachment -Path myLog.txt -IsLog -Debug |
        should be '##vso[task.uploadlog]myLog.txt'
    }

    it 'Will error when the file does not exist' {
        { Add-ADOAttachment -Path NothingThere.zip } | should throw
    }
}

describe 'Enabling Endpoints' {
    it 'Can add an endpoint' {

        Set-ADOEndpoint -ID 000-0000-0000 -Key AccessToken -AccessToken testValue -Debug |
        should be '##vso[task.setendpoint id=000-0000-0000;field=authParameter;key=AccessToken]testValue'
        Set-ADOEndpoint -ID 000-0000-0000 -Key userVariable -Value testValue -Debug |
        should be '##vso[task.setendpoint id=000-0000-0000;field=dataParameter;key=userVariable]testValue'
        Set-ADOEndpoint -ID 000-0000-0000 -Url 'https://example.com/service' -Debug |
        should be '##vso[task.setendpoint id=000-0000-0000;field=url]https://example.com/service'

    }

    it 'Will assume a -Name of AccessToken' {
        Set-ADOEndpoint -ID 000-0000-0000 -AccessToken testValue -Debug |
        should be '##vso[task.setendpoint id=000-0000-0000;field=authParameter;key=AccessToken]testValue'
    }
}

describe 'Build metadata' {
    it 'Can set a build tag' {
        Set-ADOBuild -Tag MyTag -Debug | should be '##vso[build.addbuildtag]MyTag'
    }

    it 'Can change the system path within a build' {
        Set-ADOBuild -EnvironmentPath MyPath -Debug | should be '##vso[task.prependpath]MyPath'
    }

    it 'Can set the build number' {
        Set-ADOBuild -BuildNumber 42 -Debug | should be '##vso[build.updatebuildnumber]42'
    }

    it 'Can change the release name' {
        Set-ADOBuild -ReleaseName myRelease -Debug | should be '##vso[build.updatereleasename]myRelease'
    }
}

describe 'Creating Pipelines' {
    it 'Can make a new pipeline out of existing parts' {
        New-ADOPipeline -Trigger SourceChanged | should belike '*trigger:*paths:*exclude:*.md*.txt*'
    }
    it 'Can have nested definitions' {
        $adoDef = New-ADOPipeline -Stage TestPowerShellCrossPlatform, UpdatePowerShellGallery -Trigger SourceChanged
        $adoDef | should belike '*Install PowerShell Core*'
        $adoDef | should belike '*pwsh*'
        $adoDef | should belike '*trigger:*paths:*exclude:*.md*.txt*'
    }

    it 'Can create a pipeline with a trigger and a single step' {
        New-ADOPipeline -Trigger SourceChanged -Step InstallPester |
            should belike '*trigger:*steps:*-*powershell:*'
    }

    it "Can import any module's commands and the contents of an ADO folder into build steps" {
        Get-Module PSDevOps | Import-BuildStep
    }

    it 'Can create a pipeline with parameters' {
        $createdPipeline =
            New-ADOPipeline -Step Get-ADOWorkProcess -ExcludeParameter Credential, Server, ApiVersion, UseDefaultCredentials, Proxy* -VariableParameter PersonalAccessToken

        $keyParts  =
            'steps:','- powershell','$Parameters*=*@{}','$Parameters.Organization',
            '=','Import-Module','$(PSDevOpsPath)',
            'Get-ADOWorkProcess','@Parameters'

        $createdPipeline | should belike "*$($keyParts -join '*')*"
    }
}

describe 'Calling REST APIs' {
    it 'Can invoke an Azure DevOps REST api' {
        $org = 'StartAutomating'
        $project = 'PSDevOps'
        Invoke-ADORestAPI "https://dev.azure.com/$org/$project/_apis/build/builds/?api-version=5.1" -PSTypeName AzureDevOps.Build
    }
}

describe 'Builds' {
    context 'Get-ADOBuild' {
        it 'Can get builds' {
            $mostRecentBuild = Get-ADOBuild  -Organization StartAutomating -Project PSDevOps -First 1
            $mostRecentBuild.definition.name | should belike *PSDevOps*
        }
        it 'Can get -Detail on a particular build' {
            $mostRecentBuild = Get-ADOBuild  -Organization StartAutomating -Project PSDevOps -First 1
            $detailedBuild = $mostRecentBuild | Get-ADOBuild -Detail
            $detailedBuild.Timeline | should -not -be $null
        }
        it 'Can get build definitions' {
            $buildDefinitions = @(Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition)
            $buildDefinitions.Count | should be 1
            $buildDefinitions[0].Name  |should belike *PSDevOps*
        }
        it 'Can get build -DefinitionYAML, given a build definition' {
            $buildDefinitionYaml = $(Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition |
                Select-Object -First 1 |
                Get-ADOBuild -DefinitionYAML -PersonalAccessToken $testPat)
            $buildDefinitionYaml | should belike *pester*
        }
        it 'Can Start a Build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $startWhatIf = $latestBuild | Start-ADOBuild -WhatIf
            $startWhatIf.Method | should be POST
            $startWhatIf.Body.Definition.ID | should be $latestBuild.Definition.ID

            $buildDefinitons = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition -First 1
            $startWhatIf = $buildDefinitons | Start-ADOBuild -WhatIf
            $startWhatIf.Method | should be POST
            $startWhatIf.Body.Definition.ID | should be $buildDefinitons.ID

            $startWhatIf = Start-ADOBuild -Organization StartAutomating -Project PSDevOps -WhatIf -DefinitionName $buildDefinitons.Name
            $startWhatIf.Method | should be POST
            $startWhatIf.Body.Definition.ID | should be $buildDefinitons.ID
        }

        it 'Can stop a Build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $stopWhatIf = $latestBuild | Stop-ADOBuild -WhatIf
            $stopWhatIf.Method | should be PATCH
            $stopWhatIf.Body.Status | should be cancelling
        }

        it 'Could remove a build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $whatIf = $latestBuild | Remove-ADOBuild -WhatIf
            $whatIf.Method | should be DELETE
            $whatIf.Uri | should belike "*$($latestBuild.BuildID)*"
        }
    }

    if ($testPat -ne $env:SYSTEM_ACCESSTOKEN) {
        context 'Agent Pools' {
            it 'Can Get-ADOAgentPool for a given -Organization and -Project' {
                Get-ADOAgentPool -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                    Select-Object -First 1 -ExpandProperty Name |
                    should be default
            }

            it 'Can Get-ADOAgentPool for a given -Organization' {
                Get-ADOAgentPool -Organization StartAutomating -PersonalAccessToken $testPat |
                    Select-Object -First 1 -ExpandProperty Name |
                    should be default
            }
        }

        context 'Service Endpoints:' {
            it 'Can Get-ADOServiceEndpoint' {
                Get-ADOServiceEndpoint -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                    Select-Object -First 1 -ExpandProperty Type |
                    Should be GitHub
            }
        }
    }

    context 'Extensions' {
        it 'Can Get-ADOExtension' {
            Get-ADOExtension -Organization StartAutomating -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty PublisherName |
                should be Microsoft
        }

        it 'Get Get-ADOTask' {
            Get-ADOTask -Organization StartAutomating -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty PSTypenames |
                Select-Object -Last 1 |
                should -Be 'PSDevOps.Task'
        }
    }
}

describe 'Working with Work Items' {


    it 'Can get a work item' {
        Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 1 -Field System.WorkItemType |
        Select-Object -ExpandProperty 'System.WorkItemType' |
        should be Epic
    }

    it 'Can get work item types' {
        $wiTypes = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -WorkItemType
        $wiTypeNames = $wiTypes | Select-Object -ExpandProperty Name
        if ($wiTypeNames -notcontains 'Epic') {
            throw "Expected to find an epic type"
        }
    }


    if ($env:BUILD_REQUESTEDFOR -and $env:BUILD_REQUESTEDFOR -notlike '*james*') {
        return
    }
    if ($PersonalAccessToken -or $env:SYSTEM_ACCESSTOKEN) {
        $testPat = if ($PersonalAccessToken) { $PersonalAccessToken } else { $env:SYSTEM_ACCESSTOKEN }

        context WorkProcesses {
            it 'Can get work procceses related to a project' {
                Get-ADOProject -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                    Get-ADOWorkProcess |
                        Select-Object -ExpandProperty Name |
                            should -Be 'StartAutomating Basic'
            }

            it 'Can get work item types related to a process' {
                Get-ADOProject -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                    Get-ADOWorkProcess |
                        Get-ADOWorkItemType |
                            Select-Object -First 1 -ExpandProperty Name |
                                should -Be issue
            }

            it 'Can create new work item types' {
                $whatIfResult =
                    Get-ADOProject -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                        Get-ADOWorkProcess |
                            New-ADOWorkItemType -Icon icon_flame -Color 'ddee00' -WhatIf

                $whatIfResult.body.icon |
                    should -Be icon_flame
            }

            it 'Can remove custom work item types' {
                $whatIfResult =
                    Get-ADOProject -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                        Get-ADOWorkProcess |
                            Remove-ADOWorkItemType -WorkItemTypeName Issue -WhatIf

                $whatIfResult.method | should -Be DELETE
                $whatIfResult.uri | should -BeLike *.Issue*
            }
        }


        context 'Querying Work Items' {

            it 'Can query work items' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems' -PersonalAccessToken $testPat -NoDetail
                $queryResults[0].id | should be 1
            }

            it 'Can will get work item detail by default' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems Where [System.WorkItemType] = "Epic"' -PersonalAccessToken $testPat
                $queryResults[0].'System.WorkItemType' | should be Epic
            }

            it 'Will not use workitemsbatch when using an old version of the REST api' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems Where [System.WorkItemType] = "Epic"' -PersonalAccessToken $testPat -ApiVersion '3.0'
                $queryResults[0].'System.WorkItemType' | should be Epic
            }
        }



        it 'Can create, update, and remove a work item' {
            $splat = @{Organization = $TestOrg; Project = $TestProject; PersonalAccessToken = $testPat }
            $wi = New-ADOWorkItem -InputObject @{Title = 'Test-WorkItem' } -Type Issue -ParentID 1 @splat
            $wi.'System.Title' | should be 'Test-WorkItem'
            $wi2 = Set-ADOWorkItem -InputObject @{Description = 'Testing Creating Work Items' } -ID $wi.ID @splat
            $wi2.'System.Description' | should be 'Testing Creating Work Items'
            $wi2 = Set-ADOWorkItem -InputObject @{Description = 'Updating via Query' } -Query "select [System.ID] from WorkItems Where [System.ID] = $($wi2.ID)" @splat
            $wi2.'System.Description' | should be 'Updating Via query'
            Remove-ADOWorkItem @splat -Query "select [System.ID] from WorkItems Where [System.Title] = 'Test-WorkItem'" -Confirm:$false
        }

        it 'Can get work proccesses' {
            Get-ADOWorkProcess -Organization $TestOrg -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty name |
                    should -Be Basic
        }

        it 'Can get area paths' {
            Get-ADOAreaPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Path |
                should -Be "\$testproject\Area"
        }

        it 'Can get iteration paths' {
            Get-ADOIterationPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Path |
                should -Be "\$testProject\Iteration"
        }
    }

    if ($PersonalAccessToken) {
        # These tests will not run with the system access token in AzureDevOps
        $testPat = $PersonalAccessToken
        it 'Can create and remove custom fields' {
            $splat = @{Organization = $TestOrg; Project = $TestProject; PersonalAccessToken = $testPat }
            $testFieldNumber = "TestField$([Random]::new().Next())"
            New-ADOField -Name $testFieldNumber @splat
            Remove-ADOField -Name $testFieldNumber -Confirm:$false @splat
        }

        it 'Can create and remove custom feeds' {
            $splat = @{Organization = $TestOrg; Project = $TestProject; PersonalAccessToken = $testPat }
            $TestFeedName = "TestFeed$([Random]::new().Next())"
            $newFeed = New-ADOArtifactFeed @splat -Description "Test Feed" -Name $TestFeedName
            $newFeed |
                Remove-ADOArtifactFeed @splat -Confirm:$false
        }

    }
}

describe 'Import-ADOProxy' {
    it 'Should Import a proxy module' {
        $saProxy = Import-ADOProxy -Force -Organization StartAutomating -PassThru -Prefix SA
        $saProxy.Name | should -Be SA
        Get-Command -Name Get-SABuild | Select-Object -ExpandProperty Name | should -be Get-SABuild
    }
}



describe 'GitHub Worfklow tools' {
    context New-GitHubWorkflow {
         it 'should create yaml' {
             $actual = New-GitHubWorkflow -Job TestPowerShellOnLinux
             $actual.Trim() | should belike "*run:*shell:?pwsh*"
         }
    }
    context GitHubWorkflowOutput {
        it 'Can Write an GitHub Error' {
            Write-GitHubError -Message "error!" -Debug |
            should -Match '::error::error!'
        }

        it 'Can Write an GitHub Error with a SourcePath' {
            Write-GitHubError -Message 'error!' -SourcePath file.cs -LineNumber 1 -Debug |
            should -Be '::error file=file.cs,line=1::error!'
        }

        it 'Can Write an GitHub Warning' {
            Write-GitHubWarning -Message "Warning!" -Debug |
            should -Match '::warning::Warning!'
        }

        it 'Can Write an GitHub Warning with a SourcePath' {
            Write-GitHubWarning -Message 'Warning!' -SourcePath file.cs -LineNumber 1 -Debug |
            should -Be '::warning file=file.cs,line=1::Warning!'
        }
    }
}