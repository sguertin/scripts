function Get-AzureCredentials {
    [CmdletBinding()]
    param(
        [string]$K8Name,
        [string]$ResourceGroup,
        [string]$ConfigName
    )
    
    $userProfile = $env:USERPROFILE;    
    Write-Host "Logging In...";
    Write-Host "az login"
    & az login;    
    Write-Host "Extracting Credentials...";    
    Write-Host "az aks get-credentials --resource-group $ResourceGroup --name $K8Name";
    & az aks get-credentials --resource-group $ResourceGroup --name $K8Name;
    Write-Host "COPY $userProfile\.kube\config ==> $userProfile\.kube\$ConfigName";
    Copy-Item "$userProfile\.kube\config" -Destination "$userProfile\.kube\$ConfigName";
}