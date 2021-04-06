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
        should -Match '\#\#vso\[task\.logissue type=error\]error!'
    }

    it 'Can Write an Azure DevOps Error with a SourcePath' {
        Write-ADOError -Message 'error!' -SourcePath file.cs -LineNumber 1 -Debug |
        should -Be '##vso[task.logissue type=error;sourcepath=file.cs;linenumber=1]error!'
    }

    it 'Can Write an Azure DevOps Warning Message' {
        Write-ADOWarning -Message "warning!" -Debug |
        should -Match '\#\#vso\[task\.logissue type=warning\]warning!'
    }

    it 'Can Write an Azure DevOps Warning with a SourcePath' {
        Write-ADOWarning -Message 'warning!' -SourcePath file.cs -LineNumber 1 -Debug |
        should -Be '##vso[task.logissue type=warning;sourcepath=file.cs;linenumber=1]warning!'
    }

    it 'Can Write an Azure DevOps Debug Message' {
        Write-ADODebug -Message 'debug!' -Debug |
            should -Be '##[debug]debug!'
    }

    it 'Can Write ADO output' {
        Write-ADOOutput -InputObject @{key='value'} -Debug |
            Should -Be '##vso[task.setvariable variable=key;isOutput=true]value'
    }

    it 'Will call Write-ADODebug when provided a verbose or debug message' {
        Write-Verbose "verbose" -Verbose *>&1 |
            Write-ADOOutput -Debug |
            should -Be '##[debug]verbose'
    }

    it 'Will call Write-ADOError when provided an error' {

        & { Write-Error "problem" -ErrorAction Continue} 2>&1 |
            Write-ADOOutput -Debug |
            should -BeLike '*problem'
    }

    it 'Can Write ADO output from the pipeline' {
        1 | Write-ADOOutput -Debug |
            Should -Be '##vso[task.setvariable variable=output;isoutput=true]1'
    }

    it 'Will call Write-ADOWarning when provided an error' {
        Write-Warning "problem" 3>&1 |
            Write-ADOOutput -Debug |
            should -BeLike '*warning*problem'
    }

    it 'Can write an Azure DevOps variable' {
        Write-ADOVariable -Name MyVar -Value MyValue -Debug |
        should -Match '\#\#vso\[task\.setvariable variable=MyVar\]MyValue'
    }
    it 'Can write an Azure DevOps variable that -IsSecret' {
        Write-ADOVariable -Name MySecret -Value IsSafe -IsSecret -Debug |
        should -Match '\#\#vso\[task\.setvariable variable=MySecret;issecret=true\]IsSafe'
    }
    it 'Can write an Azure DevOps variable that -IsReadOnly' {
        Write-ADOVariable -Name MyReadOnly -Value Const -isreadOnly -Debug |
        should -Match '\#\#vso\[task\.setvariable variable=MyReadOnly;isreadonly=true\]Const'
    }
    it 'Can write an Azure DevOps variable that -IsOutput' {
        Write-ADOVariable -Name out -Value output -IsOutput -Debug |
        should -Match '\#\#vso\[task\.setvariable variable=out;isoutput=true\]output'
    }

    it 'Can Trace Commands to Azure DevOps Output' {
        Trace-ADOCommand -Command Get-Process -Parameter @{id=1} -Debug |
            Should -Be '##[command]Get-Process -id 1'
    }

    it 'Can Write progress to the timeline' {
        $id = [Random]::new().Next()
        $nestedId = [Random]::new().Next()
        $p = 10
        Write-ADOProgress -Id $id -Activity 'Doing Stuff' -Status 'And Things' -PercentComplete $p -Debug |
        should -BeLike '##vso?task.logdetail*'
        $p += 10

        Write-ADOProgress -Id $nestedId -ParentId $id -Activity 'Nested Stuff' -Status 'And Things' -PercentComplete $p -Debug |
        should -BeLike '##vso?task.logdetail*parentid*'

        Write-ADOProgress -Id $id -Activity 'Doing Stuff' -Status 'Done' -Completed -Debug |
        should -BeLike '##vso?task.logdetail*completed*'

        Write-ADOProgress -Activity 'Doing Stuff' -Status 'And Things' -SecondsRemaining 10 -Debug |
        should -BeLike '*(10s*'

        Write-ADOProgress -Activity 'Doing Stuff' -Status 'And Things' -Id ([Random]::new().Next()) -CurrentOperation 'Working on a Thing' -Debug |
        should -BeLike '*(Working on a Thing)*'
    }
}

describe 'Making Attachments Easier' {
    it 'Can add a summary file' {

        Add-ADOAttachment -Path blah.md -IsSummary -Debug |
        should -Be '##vso[task.uploadsummary]blah.md'
    }

    it 'Can attach an artifact' {
        Add-ADOAttachment -Path artifact.zip -ContainerFolder artifacts -ArtifactName myArtifact -Debug |
        should -Be "##vso[artifact.upload containerfolder=artifacts;artifactname=myArtifact]artifact.zip"

    }

    it 'Can attach any old file' {
        Add-ADOAttachment -Path myUpload.zip -Debug |
        should -Be '##vso[task.uploadfile]myUpload.zip'
    }

    it 'Can attach a log file' {
        Add-ADOAttachment -Path myLog.txt -IsLog -Debug |
        should -Be '##vso[task.uploadlog]myLog.txt'
    }

    it 'Will error when the file does not exist' {
        { Add-ADOAttachment -Path NothingThere.zip } | should -Throw
    }
}

describe 'Enabling Endpoints' {
    it 'Can add an endpoint' {

        Set-ADOEndpoint -ID 000-0000-0000 -Key AccessToken -AccessToken testValue -Debug |
        should -Be '##vso[task.setendpoint id=000-0000-0000;field=authParameter;key=AccessToken]testValue'
        Set-ADOEndpoint -ID 000-0000-0000 -Key userVariable -Value testValue -Debug |
        should -Be '##vso[task.setendpoint id=000-0000-0000;field=dataParameter;key=userVariable]testValue'
        Set-ADOEndpoint -ID 000-0000-0000 -Url 'https://example.com/service' -Debug |
        should -Be '##vso[task.setendpoint id=000-0000-0000;field=url]https://example.com/service'

    }

    it 'Will assume a -Name of AccessToken' {
        Set-ADOEndpoint -ID 000-0000-0000 -AccessToken testValue -Debug |
        should -Be '##vso[task.setendpoint id=000-0000-0000;field=authParameter;key=AccessToken]testValue'
    }
}

describe 'Build metadata' {
    it 'Can set a build tag' {
        Set-ADOBuild -Tag MyTag -Debug | should -Be '##vso[build.addbuildtag]MyTag'
    }

    it 'Can change the system path within a build' {
        Set-ADOBuild -EnvironmentPath MyPath -Debug | should -Be '##vso[task.prependpath]MyPath'
    }

    it 'Can set the build number' {
        Set-ADOBuild -BuildNumber 42 -Debug | should -Be '##vso[build.updatebuildnumber]42'
    }

    it 'Can change the release name' {
        Set-ADOBuild -ReleaseName myRelease -Debug | should -Be '##vso[build.updatereleasename]myRelease'
    }
}

describe 'Creating Pipelines' {
    it 'Can make a new pipeline out of existing parts' {
        New-ADOPipeline -Trigger SourceChanged | should -BeLike '*trigger:*paths:*exclude:*.md*.txt*'
    }
    it 'Can have nested definitions' {
        $adoDef = New-ADOPipeline -Stage TestPowerShellCrossPlatform, UpdatePowerShellGallery -Trigger SourceChanged
        $adoDef | should -BeLike '*Install PowerShell Core*'
        $adoDef | should -BeLike '*pwsh*'
        $adoDef | should -BeLike '*trigger:*paths:*exclude:*.md*.txt*'
    }

    it 'Can create a pipeline with a trigger and a single step' {
        New-ADOPipeline -Trigger SourceChanged -Step InstallPester |
            should -BeLike '*trigger:*steps:*-*powershell:*'
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

        $createdPipeline | should -BeLike "*$($keyParts -join '*')*"
    }
}

describe 'Calling REST APIs' {
    it 'Can invoke an Azure DevOps REST api' {
        $org = 'StartAutomating'
        $project = 'PSDevOps'
        Invoke-ADORestAPI "https://dev.azure.com/$org/$project/_apis/build/builds/?api-version=5.1" -PSTypeName AzureDevOps.Build
    }

    it 'Can Connect to Azure DevOps (Connect-ADO)' {
        $connection = Connect-ADO -Organization StartAutomating -PersonalAccessToken $testPat
        $connection.Organization | Should -Be StartAutomating
    }

    it 'Can Disconnect from AzureDevops (Disconnect-ADO)' {
        Disconnect-ADO -Confirm:$false
        Disconnect-ADO -WhatIf | Should -Be $null
    }

    it 'Can Import a proxy module (Import-ADOProxy)' {
        $saProxy = Import-ADOProxy -Force -Organization StartAutomating -PassThru -Prefix SA
        $saProxy.Name | should -Be SA
        Get-Command -Name Get-SABuild | Select-Object -ExpandProperty Name | should -be Get-SABuild
    }

    context Projects {
        it 'Can get projects' {
            Get-ADOProject -Organization StartAutomating -Project PSDevOps |
                Select-Object -ExpandProperty Name |
                    Should -Be PSDevOps
        }
        it 'Can create projects' {
            $whatIfResult =
                New-ADOProject -Name TestProject -Description "A Test Project" -Public -Abbreviation 'TP' -Organization StartAutomating -Process Agile -WhatIf -PersonalAccessToken $testPat
            $bodyObject = $whatIfResult.body | ConvertFrom-Json
            $bodyObject.name |
                Should -Be TestProject
            $bodyObject.description |
                Should -Be "A Test Project"
        }

        it 'Can set project properties' {
            Get-ADOProject -Org StartAutomating -Project PSDevOps |
                Set-ADOProject -WhatIf -Metadata @{Key='value'} |
                ForEach-Object {
                    $in = $_
                    $in.Body.Path | Should -Be /Key
                    $in.Body.Value | should -Be value
                }
        }

        it 'Can remove projects' {
            $whatIf = Get-ADOProject -Organization StartAutomating -Project PSDevOps |
                Remove-ADOProject -WhatIf
            $whatIf.Uri | Should -BeLike '*StartAutomating/_apis/projects/*'
            $whatIf.Method | Should -Be DELETE
        }
    }

    context Teams {
        it 'Can get teams' {
            Get-ADOTeam -Organization StartAutomating -Project PSDevOps -TeamID 'PSDevOps Team' -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Name |
                should -Be 'PSDevOps Team'
        }

        it 'Can create teams' {
            $whatIf = Add-ADOTeam -Organization StartAutomating -Project PSDevOps -Team MyTeam -WhatIf
            $whatIf.body.name | Should -Be MyTeam
        }

        it 'Can remove teams' {
            $whatIf = Remove-ADOTeam -Organization StartAutomating -Project PSDevOps -TeamID MyTeam -WhatIf
            $whatIf.uri    | Should -BeLike '*/MyTeam*'
            $whatIf.Method | Should -Be DELETE
        }
    }

    context Repositories {
        it 'Can get repositories' {
            Get-ADORepository -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Name |
                    Should -Be PSDevOps
        }
        it 'Can create repositories' {
            $whatIf =
                New-ADORepository -Organization StartAutomating -Project PSDevOps -RepositoryName NewRepo -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method |
                Should -Be POST
            $whatIf.body.name |
                Should -Be NewRepo
            $whatIf.Uri |
                Should -BeLike '*/git/repositories*'
        }

        it 'Can Remove Repositories' {
            $whatIf =
                Remove-ADORepository -Organization StartAutomating -Project PSDevOps -RepositoryID PSDevOps -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method | Should -Be DELETE
            $whatIf.Uri | Should -BeLike '*/git/repositories/*'
        }
    }

    context 'Builds' {
        it 'Can get builds' {
            $mostRecentBuild = Get-ADOBuild  -Organization StartAutomating -Project PSDevOps -First 1
            $mostRecentBuild.definition.name | should -BeLike *PSDevOps*
        }
        it 'Can get -Detail on a particular build' {
            $mostRecentBuild = Get-ADOBuild  -Organization StartAutomating -Project PSDevOps -First 1
            $detailedBuild = $mostRecentBuild | Get-ADOBuild -Detail
            $detailedBuild.Timeline | should -not -be $null
        }
        it 'Can get build definitions' {
            $buildDefinitions = @(Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition)
            $buildDefinitions.Count | should -BeGreaterThan 1
            $buildDefinitions[0].Name  |should -beLike *PSDevOps*
        }
        it 'Can get build -DefinitionYAML, given a build definition' {
            $buildDefinitionYaml = $(Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition |
                Select-Object -First 1 |
                Get-ADOBuild -DefinitionYAML -PersonalAccessToken $testPat)
            $buildDefinitionYaml | should -beLike *pester*
        }

        it 'Can create a build' {
            $buildDefinitions = @(Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition)
            $bd = $buildDefinitions[0]  | Get-ADOBuild
            $whatIf = New-ADOBuild -Name 'PSDevOps3' -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $myPat -WhatIf -Repository $bd.repository -YAMLFileName azure-pipelines.yml -Variable @{MyVariable=1} -Secret @{MySecret='IsSafe'}
            $whatIf.Method | Should -Be POST
            $whatIf.Body.Process.type | Should -be 2
            $whatIf.Body.Process.yamlFileName | Should -be 'azure-pipelines.yml'
            $whatIf.Body.queue.name | Should -Be 'default'
            $whatIf.Body.path | Should -Be '\'
        }
        it 'Can Start a Build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $startWhatIf = $latestBuild | Start-ADOBuild -WhatIf
            $startWhatIf.Method | should -Be POST
            $startWhatIf.Body.Definition.ID | should -Be $latestBuild.Definition.ID
            $startWhatIf.Body.Parameters | Should -Be $null

            $buildDefinitons = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition -First 1
            $startWhatIf = $buildDefinitons | Start-ADOBuild -WhatIf
            $startWhatIf.Method | should -Be POST
            $startWhatIf.Body.Definition.ID | should -Be $buildDefinitons.ID

            $startWhatIf = Start-ADOBuild -Organization StartAutomating -Project PSDevOps -WhatIf -DefinitionName $buildDefinitons.Name -Debug
            $startWhatIf.Method | should -Be POST
            $startWhatIf.Body.Definition.ID | should -Be $buildDefinitons.ID
            $startWhatIf.Body.Parameters | Should -BeLike '*System.DebugContext*'
        }

        it 'Can stop a Build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $stopWhatIf = $latestBuild | Stop-ADOBuild -WhatIf
            $stopWhatIf.Method | should -Be PATCH
            $stopWhatIf.Body.Status | should -Be cancelling
        }

        it 'Could remove a build' {
            $latestBuild = Get-ADOBuild -Organization StartAutomating -Project PSDevOps -First 1
            $whatIf = $latestBuild | Remove-ADOBuild -WhatIf
            $whatIf.Method | should -Be DELETE
            $whatIf.Uri | should -BeLike "*$($latestBuild.BuildID)*"
        }

        it 'Could update a build' {
            $whatIf = Update-ADOBuild -Organization MyOrg -Project MyProject -BuildID 1 -Build @{KeepForever=$true} -WhatIf
            $whatIf.Uri | should -BeLike '*/builds/*'
            $whatIf.Method | should -Be PATCH
            $whatIf.Body.KeepForever | should -Be $true
        }
    }

    context 'Agent Pools' {
        # These tests will return nothing when run with a SystemAccessToken, so we will only fail if they error
        it 'Can Get-ADOAgentPool for a given -Organization and -Project' {
            Get-ADOAgentPool -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat -ErrorAction Stop
        }

        it 'Can Get-ADOAgentPool for a given -Organization' {
            Get-ADOAgentPool -Organization StartAutomating -PersonalAccessToken $testPat -ErrorAction Stop
        }

        it 'Can Remove-ADOAgentPool' {
            $whatIf = Remove-ADOAgentPool -Organization StartAutomating -PoolID 1 -WhatIf
            $whatIf.Method | Should -be DELETE
            $whatIf.Uri    | Should -BeLike '*pools/1*'
        }

        it 'Can Remove-ADOAgentPool -AgentID' {
            $whatIf = Remove-ADOAgentPool -Organization StartAutomating -PoolID 1 -AgentID 1 -WhatIf
            $whatIf.Method | Should -be DELETE
            $whatIf.Uri    | Should -BeLike '*agents/1*'
        }
    }

    context 'Service Endpoints:' {
        it 'Can Get-ADOServiceEndpoint' {
            Get-ADOServiceEndpoint -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat -ErrorAction Stop
        }

        it 'Can create service endpoints' {
            $whatIf =
                New-ADOServiceEndpoint -Organization MyOrg -Project MyProject -Name MyGitHubConnection -Url https://github.com -Type GitHub -Authorization @{
                    scheme = 'PersonalAccessToken'
                    parameters = @{
                        accessToken = $MyGitHubPersonalAccessToken
                    }
                } -PersonalAccessToken $MyAzureDevOpsPersonalAccessToken -Data @{pipelinesSourceProvider='github'} -WhatIf
            $whatIf.Body.Name | Should -Be MyGitHubConnection
            $whatIf.Uri | Should -BeLike *serviceendpoint/endpoints*
        }

        it 'Can remove service endpoints' {
            $whatIf =
                Remove-ADOServiceEndpoint -Organization MyOrg -Project MyProject -EndpointID MyGitHubConnection -WhatIf
            $whatIf.Method | Should -Be DELETE
            $whatIf.Uri | Should -BeLike '*/serviceendpoint/endpoints/*'
        }
    }

    context 'Extensions' {
        it 'Can Get-ADOExtension' {
            Get-ADOExtension -Organization StartAutomating -PersonalAccessToken $testPat -PublisherID ms -ExtensionID feed |
                Select-Object -First 1 -ExpandProperty PublisherName |
                should -Be Microsoft
        }
        <#
        it 'Can Get-ADOExtension -Contribution' {
            Get-ADOExtension -Organization StartAutomating -PersonalAccessToken $testPat -AssetType ms-vss-dashboards-web-widget -Contribution |
                Select-Object -First 1 -ExpandProperty Type |
                Should -Be ms.vss-dashboards-web.widget
        }
        #>

        it 'Can Get-ADOExtension with filters' {
            Get-ADOExtension -Organization StartAutomating -PersonalAccessToken $testPat -PublisherNameLike Micro* -ExtensionNameLike *feed* -PublisherNameMatch ms -ExtensionNameMatch feed |
                Select-Object -First 1 -ExpandProperty PublisherName |
                Should -Be Microsoft
        }

        it 'Can Install-ADOExtension' {
            $whatIf =
                Install-ADOExtension -Organization StartAutomating -PublisherID YodLabs -ExtensionID yodlabs-githubstats -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method | Should -Be POST
            $whatIf.Uri | Should -BeLike '*/YodLabs/yodlabs-githubstats*'
        }

        it 'Can Uninstall-ADOExtension' {
            $whatIf =
                Uninstall-ADOExtension -Organization StartAutomating -PublisherID YodLabs -ExtensionID yodlabs-githubstats -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method | Should -Be DELETE
            $whatIf.Uri | Should -BeLike '*/YodLabs/yodlabs-githubstats*'
        }

        it 'Can Enable-ADOExtension' {
            $whatIf =
                Enable-ADOExtension -Organization StartAutomating -PublisherID YodLabs -ExtensionID yodlabs-githubstats -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method | Should -Be PATCH
            $whatIf.Uri | Should -BeLike '*/extensionmanagement/installedextensions*'
            $whatIf.body.installState.flags | Should -Be none
        }

        it 'Can Disable-ADOExtension' {
            $whatIf =
                Disable-ADOExtension -Organization StartAutomating -PublisherID YodLabs -ExtensionID yodlabs-githubstats -WhatIf -PersonalAccessToken $testPat
            $whatIf.Method | Should -Be PATCH
            $whatIf.Uri | Should -BeLike '*/extensionmanagement/installedextensions*'
            $whatIf.body.installState.flags | Should -Be disabled
        }



        it 'Get Get-ADOTask' {
            Get-ADOTask -Organization StartAutomating -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty PSTypenames |
                Select-Object -Last 1 |
                should -Be 'PSDevOps.Task'
        }
    }

    context Dashboards {
        it 'Can get dashboards' {
            Get-ADODashboard -Organization StartAutomating -PersonalAccessToken $testPat -Project PSDevOps -Team 'PSDevOps Team' |
                Select-Object -First 1 -ExpandProperty Name |
                Should -Be Status
        }

        it 'Can add dashboards' {
            $whatIf =
                Add-ADODashboard -Organization StartAutomating -Project PSDevOps -Team 'PSDevOps Team' -Name TestDashboard -Description "A Test Dashboard" -WhatIf
            $whatIf.Method | Should -Be POST
            $whatIf.Body.name | Should -Be TestDashboard
        }

        it 'Can remove dashboards' {
            $whatIf = Remove-ADODashboard -Organization StartAutomating -Project PSDevOps -Team 'PSDevOps Team' -WhatIf -DashboardID ([GUID]::NewGuid())
            $whatIf.Uri | Should -BeLike '*/dashboard/dashboards*'
            $whatIf.Method | Should -Be DELETE
        }

        it 'Can clear dashboards' {
            $whatIf = @(Get-ADODashboard -Organization StartAutomating -PersonalAccessToken $testPat -Project PSDevOps -Team 'PSDevOps Team' |
                Select-Object -First 1 |
                Clear-ADODashboard -WhatIf)
            $whatIf |
                ForEach-Object {
                    $_.Uri | Should -BeLike '*/dashboards/*/widgets/*'
                    $_.Method | Should -Be DELETE
                }
        }

        it 'Can clear widgets settings within dashboards' {
            $whatIf = @(Get-ADODashboard -Organization StartAutomating -PersonalAccessToken $testPat -Project PSDevOps -Team 'PSDevOps Team' |
                Select-Object -First 1 |
                Get-ADODashboard -Widget |
                Select-Object -First 1 |
                Clear-ADODashboard -WhatIf)
            $whatIf.Method | Should -Be PUT
            $whatIf.body.settings | Should -Be 'null'
        }

        it 'Can update dashboards' {
            $whatIf = Get-ADODashboard -Organization StartAutomating -PersonalAccessToken $testPat -Project PSDevOps -Team 'PSDevOps Team' |
                Get-ADODashboard -Widget |
                Select-Object -First 1 |
                Update-ADODashboard -Setting @{
                    Owner = 'StartAutomating'
                    Project = 'PSDevOps'
                } -WhatIf
            $whatIf.Method | Should -Be PUT
            $whatIf.Body.settings | Should -BeLike '*isValid*:*true*'
        }
    }

    context 'Service Hooks' {
        it 'Can Get Publishers of Service Hooks' {
            Get-ADOServiceHook -Organization StartAutomating -PersonalAccessToken $testPat -Publisher |
                Select-Object -First 1 -ExpandProperty ID |
                Should -be Audit
        }
        it 'Can Get Consumers of Service Hooks' {
            Get-ADOServiceHook -Organization StartAutomating -PersonalAccessToken $testPat -Consumer |
                Select-Object -First 1 -ExpandProperty ID |
                Should -be appVeyor
        }
    }

    context 'Artifact Feeds' {
        it 'Can get artifact feeds' {
            Get-ADOArtifactFeed -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Name |
                Should -Be Builds
        }

        it 'Can create artifact feeds' {
            $whatIf =
                New-ADOArtifactFeed -Organization StartAutomating -Project PSDevOps -Name FeedTest -PublicUpstream Maven, NPM, NuGet, PyPi -Description "a test feed" -WhatIf -NoBadge
            $whatIf.Uri | Should -BeLike '*/feeds*'
            $whatIf.Body.badgesEnabled | Should -Be $false
            $whatIf.Body.UpstreamSources.Count | Should -Be 4
        }

        it 'Can update artifact feeds' {
            $whatIf =
                Set-ADOArtifactFeed -Organization StartAutomating -Project PSDevOps -FeedId 'Builds' -Description 'Project Builds' -PublicUpstream Maven, NPM, NuGet, PyPi -WhatIf
            $whatIf.Method | Should -Be PATCH
            $whatIf.Uri    | Should -BeLike */*
            $whatIf.Body.Description | Should -Be 'Project Builds'
        }

        it 'Can set artifact feed retention policies' {
            $whatIf =
                Set-ADOArtifactFeed -RetentionPolicy -Organization StartAutomating -Project PSDevOps -FeedId 'Builds' -WhatIf -DaysToKeep 10 -CountLimit 1
            $whatIf.Method | Should -Be PUT
            $whatIf.Uri    | Should -BeLike */retentionpolic*
            $whatIf.Body.daysToKeepRecentlyDownloadedPackages |
                Should -Be 10
            $whatIf.Body.countLimit |
                Should -Be 1
        }

        it 'Can remove artifact feeds' {
            $whatIf = Get-ADOArtifactFeed -Organization StartAutomating -Project PSDevOps -PersonalAccessToken $testPat |
                Remove-ADOArtifactFeed -WhatIf

            $whatIf.Method | Select-Object -Unique | Should -Be DELETE
            $whatIf.Uri | Select-Object -Unique | Should -BeLike '*/feeds/*'
        }
    }

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
}
describe 'Working with Work Items' {
    it 'Can get a work item' {
        Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 1 -Field System.WorkItemType |
        Select-Object -ExpandProperty 'System.WorkItemType' |
        should -Be Epic
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
        context 'Querying Work Items' {

            it 'Can query work items' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems' -PersonalAccessToken $testPat -NoDetail
                $queryResults[0].id | should -be 1
            }

            it 'Can will get work item detail by default' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems Where [System.WorkItemType] = "Epic"' -PersonalAccessToken $testPat
                $queryResults[0].'System.WorkItemType' | should -be Epic
            }

            it 'Will not use workitemsbatch when using an old version of the REST api' {
                $queryResults = Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems Where [System.WorkItemType] = "Epic"' -PersonalAccessToken $testPat -ApiVersion '3.0'
                $queryResults[0].'System.WorkItemType' | should -be Epic
            }
        }



        it 'Can create, update, and remove a work item' {
            $splat = @{Organization = $TestOrg; Project = $TestProject; PersonalAccessToken = $testPat }
            $wi = New-ADOWorkItem -InputObject @{Title = 'Test-WorkItem' } -Type Issue -ParentID 1 @splat
            $wi.'System.Title' | should -be 'Test-WorkItem'
            $wi2 = Set-ADOWorkItem -InputObject @{Description = 'Testing Creating Work Items' } -ID $wi.ID @splat
            $wi2.'System.Description' | should -be 'Testing Creating Work Items'
            $wi2 = Set-ADOWorkItem -InputObject @{Description = 'Updating via Query' } -Query "select [System.ID] from WorkItems Where [System.ID] = $($wi2.ID)" @splat
            $wi2.'System.Description' | should -be 'Updating Via query'
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

        it 'Can add area paths' {
            $whatIf =
                Add-ADOAreaPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat -WhatIf -AreaPath NewArea
            $whatIf.body.name |
                Should -Be NewArea
            $whatIf.Uri |
                Should -BeLike */classificationNodes/Areas*
        }

        it 'Can remove area paths' {
            $whatIf =
                Remove-ADOAreaPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat -WhatIf -AreaPath NewArea

            $whatIf.Method  |Should -Be DELETE
            $whatIf.Uri | Should -BeLike '*/classificationNodes/Areas/NewArea*'
        }

        it 'Can get iteration paths' {
            Get-ADOIterationPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat |
                Select-Object -First 1 -ExpandProperty Path |
                should -Be "\$testProject\Iteration"
        }


        it 'Can add iteration paths' {
            $whatIf =
                Add-ADOIterationPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat -WhatIf -IterationPath NewIteration -StartDate ([DateTime]::Now.Date) -EndDate ([DateTime]::Now.Date.AddDays(7))
            $whatIf.body.name |
                Should -Be NewIteration
            $whatIf.Uri |
                Should -BeLike */classificationNodes/Iterations*
            ($whatIf.body.attributes.startDate -as [DateTime]).Date |
                Should -Be ([DateTime]::Now).Date
        }

        it 'Can remove iteration paths' {
            $whatIf =
                Remove-ADOIterationPath -Organization $TestOrg -Project $TestProject -PersonalAccessToken $testPat -WhatIf -IterationPath NewIteration

            $whatIf.Method  |Should -Be DELETE
            $whatIf.Uri | Should -BeLike '*/classificationNodes/iterations/NewIteration*'
        }

        it 'Can add fields and populate a list at the same time' {
            $whatIfList, $whatIfField =
                New-ADOField -Name Verb -ReferenceName Cmdlet.Verb -Description "The PowerShell Verb" -ValidValue (
                    Get-Verb | Select-Object -ExpandProperty Verb | Sort-Object
                ) -Organization MyOrganization -WhatIf
            $whatIfList.Uri | Should -BeLike '*/lists*'
            $whatIfList.Body.type | Should -Be String
            $whatIfField.Uri | Should -BeLike '*/fields*'
            $whatIfField.Body.referenceName| Should -Be 'Cmdlet.Verb'
        }

        context Picklists {
            it 'Can get picklists, including -Orphan picklists' {
                $orphanedPicklists = Get-ADOPicklist -Organization $TestOrg -Orphan -PersonalAccessToken $testPat
                $orphanedPicklists | ForEach-Object {
                    $_.id | Should -Not -Be $null
                }
            }
            it 'Can add a new picklist' {
                $whatIf = Add-ADOPicklist -Organization $TestOrg -PicklistName MyTShirtSize -WhatIf -Item S, M, L
                $whatIf.body.name | Should -Be MyTShirtSize
                $s, $m, $l = $whatIf.Body.items
                $s | Should -Be 'S'
                $m | Should -Be 'M'
                $L | Should -Be 'L'
            }
            it 'Can remove a picklist' {
                $whatIf = Remove-ADOPicklist -Organization $TestOrg -PicklistID ([guid]::NewGuid()) -WhatIf
                $whatIf.Method | Should -Be DELETE
                $whatIf.Uri    | Should -BeLike '*_apis/work/processes/lists/*'
            }
            it 'Can update a picklist' {
                $whatIf = Update-ADOPicklist -Organization $TestOrg -PicklistID ([guid]::NewGuid()) -WhatIf -IsSuggested -Item a
                $whatIf.Method | Should -Be PUT
                $whatIf.Uri    | Should -BeLike '*_apis/work/processes/lists/*'
                $whatIf.Body.isSuggested | Should -Be $true
                $whatIf.Body.items | Select-Object -First 1 | Should -Be a
            }
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

describe 'GitHub Worfklow tools' {
    context New-GitHubWorkflow {
         it 'should create yaml' {
             $actual = New-GitHubWorkflow -Job TestPowerShellOnLinux
             $actual.Trim() | should -belike "*run:*shell:?pwsh*"
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

        it 'Can Write a GitHub Warning' {
            Write-GitHubWarning -Message "Warning!" -Debug |
            should -Match '::warning::Warning!'
        }

        it 'Can Write a Github Debug Message' {
            Write-GitHubDebug -Message "Debug" -Debug |
            should -Match '::debug::Debug'
        }

        it 'Can Write a GitHub Warning with a SourcePath' {
            Write-GitHubWarning -Message 'Warning!' -SourcePath file.cs -LineNumber 1 -Debug |
            should -Be '::warning file=file.cs,line=1::Warning!'
        }



        it 'Can Write GitHub output' {
            Write-GitHubOutput -InputObject @{key='value'} -Debug |
                Should -Be '::set-output name=key::value'
        }

        it 'Will call Write-GitHubDebug when provided a verbose or debug message' {
            Write-Verbose "verbose" -Verbose *>&1 |
                Write-GitHubOutput -Debug |
                should -BeLike '::debug::verbose'
        }

        it 'Will call Write-GitHubError when provided an error' {

            & { Write-Error "problem" -ErrorAction Continue} 2>&1 |
                Write-GitHubOutput -Debug |
                should -BeLike '*::problem'
        }

        it 'Can Write GitHub output from the pipeline' {
            1 | Write-GitHubOutput -Debug |
                Should -Be '::set-output name=output::1'
        }

        it 'Will call Write-GitHubWarning when provided an error' {
            Write-Warning "problem" 3>&1 |
                Write-GitHubOutput -Debug |
                should -BeLike '::warning*::problem'
        }

        it 'Can Trace Commands to GitHub Output' {
            Trace-GitCommand -Command Get-Process -Parameter @{id=1} -Debug |
                Should -Be '::debug::Get-Process -id 1'
        }


        it 'Can mask output' {
            Hide-GitOutput -Message "secret" -Debug |
                should -Be "::add-mask::secret"
        }

    }
}