@{
    name = "Log in with Azure"
    uses = "azure/login@v1"
    with = @{
        creds = '${{ secrets.AZURE_CREDENTIALS }}'
        'enable-AzPSSession' = $true
    }
}

<#      - name: Log in with Azure
        uses: azure/login@v1
        with:
          creds: '${{ secrets.AZURE_CREDENTIALS }}'
          enable-AzPSSession: true
#>
<#
      - name: Azure PowerShell Action
        uses: Azure/powershell@v1
        with:
          inlineScript: Get-AzVM -ResourceGroupName "< YOUR RESOURCE GROUP >"
          azPSVersion: 3.1.0
#>