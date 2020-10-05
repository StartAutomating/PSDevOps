New-ADOPipeline -Stage PowerShellStaticAnalysis, TestPowerShellCrossPlatform, UpdatePowerShellGallery -Option @{
    'TestPowerShellCrossPlatform'=@{
        env=@{
            'SYSTEM_ACCESSTOKEN'='$(SYSTEM.ACCESSTOKEN)'
        }
    }
} |
    Set-Content .\azure-pipelines.yml -Encoding UTF8
