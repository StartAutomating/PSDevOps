[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name ScriptCop -Repository PSGallery -Force -Scope CurrentUser
Import-Module ScriptCop -Force -PassThru