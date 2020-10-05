@{
    name = 'PublishTestResults'
    uses = 'actions/upload-artifact@v2'
    with = @{
        name = 'PesterResults'
        path = '**.TestResults.xml'
    }
    if = '${{always()}}'
}
