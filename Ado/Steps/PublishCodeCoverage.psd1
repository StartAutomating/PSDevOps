@{
    task = 'PublishCodeCoverageResults@1'
    inputs = @{
        codeCoverageTool    = 'JaCoCo'
        summaryFileLocation = '**/*.Coverage.xml'
        reportDirectory     = '$(System.DefaultWorkingDirectory)'
    }
    condition = 'always()'
}