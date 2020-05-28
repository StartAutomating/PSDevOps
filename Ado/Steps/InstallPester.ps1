param(
[string]
$PesterMaxVersion = '4.9.9'
)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser -MaximumVersion $PesterMaxVersion 
Import-Module Pester -Force -PassThru -MaximumVersion $PesterMaxVersion