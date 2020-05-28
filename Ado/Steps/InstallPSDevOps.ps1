[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name PSDevOps -Repository PSGallery -Force -Scope CurrentUser
Import-Module PSDevOps -Force -PassThru