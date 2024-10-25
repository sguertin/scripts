function Switch-Service {
    [cmdletBinding()]
    param(
        [string]$Name
    )
    $service = $null;
    try {
        $service = Get-Service $Name -ErrorAction Stop;
        if ($service.Status -eq "Running") {
            Write-Host "Stopping $Name Service...";
            Stop-Service $Name;
        } else {
            Write-Host "Starting $Name Service...";
            Start-Service $Name
        }    
    } catch {
        Write-Warning "Could not find Service '$Name'";
    }
}
Set-Alias -Name toggle -Value Switch-Service;