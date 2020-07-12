[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force -Scope CurrentUser
Import-Module PSScriptAnalyzer -Force -PassThru