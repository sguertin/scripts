function Start-KubernetesBrowse {
    [CmdletBinding()]
    param(
        $Group,
        $Name
    )
    try {
        Get-Command "az" -ErrorAction Stop | Out-Null;
    } catch {
        Write-Error "az not found in PATH!"
        return 1;
    }
    Write-Host "az aks browse --resource-group $Group --name $Name";
    az aks browse --resource-group $Group --name $Name
}
Set-Alias -Name clusterbrowse -Value Start-KubernetesBrowse;