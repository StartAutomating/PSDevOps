@{
    name = 'PublishTestResults'
    uses = 'actions/upload-artifact@v3'
    with = @{
        name = 'PesterResults'
        path = '**.TestResults.xml'
    }
    if = '${{always()}}'
}
