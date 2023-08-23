function Get-ConnectionString {
    [cmdletBinding()]
    param(
        [ValidateSet("Development, Quality, Hotfix, Production")]
        [string]$Environment = "Hotfix",
        [ValidateSet("Legacy, Application")]
        [string]$Application = "Legacy"
    )
    $connectionFilePath = Join-Path $env:USERPROFILE -ChildPath "Documents" -AdditionalChildPath @("Connections.json");
    if ((Test-Path $connectionFilePath) -eq $false) {
        Write-Error "Unable to locate '$connectionFilePath'!"
    }
    $Connections = Get-Content -Path $connectionFilePath -Raw | ConvertFrom-Json;
    $connectionString = $Connections.BaseConnectionString;
    $database = $Connections.Databases.($Application);
    $server = $Connections.Servers.($Application).($Environment);

    return $connectionString.Replace("#Server#", $server).Replace("#Database#",$database);
}
