@{
    task= 'PublishTestResults@2'
    inputs =  @{
        testResultsFormat= 'NUnit'
        testResultsFiles= '**/*.TestResults.xml'
        mergeTestResults= $true
    }
}