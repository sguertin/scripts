function Get-AzureCredentials {
    [CmdletBinding()]
    param(
        [switch]$Development = $false,
        [switch]$Test 
    )
    if (($Development -eq $true) -and ($Test -eq $true)) {
        Write-Error "Development and Test flags are mutually exclusive."
        return;
    }
    $userProfile = $env:USERPROFILE;
    if ($Development -eq $true) {
        $configName = "dev-config";
        $resourceGroup = "vc-dev-k8s-rg";
        $name = "vc-dev-k8s";        
    } else {
        $configName = "tst-config";
        $resourceGroup = "vc-tst-k8s-rg";
        $name = "vc-tst-k8s";
    }
    Write-Host "Logging In...";
    Write-Host "az login"
    & az login;    
    Write-Host "Extracting Credentials...";    
    Write-Host "az aks get-credentials --resource-group $resourceGroup --name $name";
    & az aks get-credentials --resource-group $resourceGroup --name $name;
    Write-Host "COPY $userProfile\.kube\config ==> $userProfile\.kube\$configName";
    Copy-Item "$userProfile\.kube\config" -Destination "$userProfile\.kube\$configName";
}