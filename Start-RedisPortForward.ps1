function Start-RedisPortForward {
    $command = "pwsh";
    try {
        Get-Command $command -ErrorAction Stop | Out-Null;
    } catch {
        $command = "powershell";
    }
    $dir = $env:USERPROFILE + "\scripts";
    
    Push-Location $dir;

    $portforward1 = Resolve-Path "PortForward\PortForwardRedis.ps1"
    
    Write-Host $portforward1
    Start-Process -FilePath $command -ArgumentList "-file $portforward1"
    
    Pop-Location;
}
