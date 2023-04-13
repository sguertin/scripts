function Get-AzureCredentials {
    [CmdletBinding()]
    param(
        [string]$K8Name,
        [string]$ResourceGroup,
        [string]$ConfigName
    )

    Write-Host "Logging In...";
    Write-Host "az login"
    & az login;
    Write-Host "Extracting Credentials...";
    Write-Host "az aks get-credentials --resource-group $ResourceGroup --name $K8Name";
    & az aks get-credentials --resource-group $ResourceGroup --name $K8Name;
    Write-Host "COPY $env:USERPROFILE\.kube\config ==> $env:USERPROFILE\.kube\$ConfigName";
    Copy-Item "$env:USERPROFILE\.kube\config" -Destination "$env:USERPROFILE\.kube\$ConfigName";
}