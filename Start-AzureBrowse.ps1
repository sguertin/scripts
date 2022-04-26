function Start-AzureBrowse {
    [CmdletBinding()]
    param(
        [switch]$Development,
        [switch]$Test
    )
    if (($Development -eq $true) -and ($Test -eq $true)) {
        Write-Error "Development and Test flags are mutually exclusive."
        return;
    }
    if ($Development -eq $true) {
        $environment = "Development";
        $resourceGroup = "vc-dev-k8s-rg";
        $name = "vc-dev-k8s";        
    } else {
        $environment = "Test";
        $resourceGroup = "vc-tst-k8s-rg";
        $name = "vc-tst-k8s";
    }
    Write-Host "Starting Azure Kubernetes browse for $environment";
    Write-Host "az aks browse --resource-group $resourceGroup --name $name";
    az aks browse --resource-group $resourceGroup --name $name
}