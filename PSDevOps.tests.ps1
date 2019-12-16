param(
    [string]
    $TestOrg = 'StartAutomating',
    [string]
    $TestProject = 'PSDevOps'
)

import-module .\PSDevOps.psd1 -Force

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
}

describe 'Calling REST APIs' {
    it 'Can invoke an Azure DevOps REST api' {
        $org = 'StartAutomating'
        $project = 'PSDevOps'
        Invoke-ADORestAPI "https://dev.azure.com/$org/$project/_apis/build/builds/?api-version=5.1" -PSTypeName AzureDevOps.Build
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
            should be Basic
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
            New-ADOArtifactFeed @splat -Description "Test Feed" -Name $TestFeedName |
                Remove-ADOArtifactFeed @splat -Confirm:$false
        }

    }
}


describe 'New-GitHubAction' {
     it 'should create yaml' {
         $actual = New-GitHubAction -Step InstallPester
         $actual.Trim() | should belike "*runs:*shell:?pwsh*"
     }
}