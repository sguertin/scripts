function Start-AzureBrowse {
    [CmdletBinding()]
    param(
        $Environment,
        $ResourceGroup,
        $Name
    )
    if (($Development -eq $true) -and ($Test -eq $true)) {
        Write-Error "Development and Test flags are mutually exclusive."
        return;
    }

    Write-Host "Starting Azure Kubernetes browse for $Environment";
    Write-Host "az aks browse --resource-group $ResourceGroup --name $Name";
    & az aks browse --resource-group $ResourceGroup --name $Name
}