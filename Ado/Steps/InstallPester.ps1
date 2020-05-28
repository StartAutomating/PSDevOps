param(
[string]
$PesterMaxVersion = '4.9.9'
)
Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser -MaximumVersion $PesterMaxVersion
Import-Module Pester -Force -PassThru