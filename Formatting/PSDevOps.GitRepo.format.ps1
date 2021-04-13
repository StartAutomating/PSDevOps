Write-FormatView -TypeName PSDevOps.GitRepo -Property Name, '*', '!', Description  -VirtualProperty @{
    '*' = {$_.'stargazers_count'}
    '!' = {$_.'open_issues_count'}
    '/' = {$_.'forks_count'}
} -Wrap  -Width 30,-5, 5, 5, 0 -GroupByProperty OwnerName
