function Start-KafkaPortForward {
    
    [CmdletBinding()]
    param()
    $command = "pwsh";
    try {
        Get-Command $command -ErrorAction Stop | Out-Null;
        Write-Host "Powershell Core (pwsh) detected...";
    } catch {
        Write-Host "Unable to locate pwsh, reverting to powershell...";
        $command = "powershell";
    }
    $dir = $env:USERPROFILE + "\scripts";

    Write-Host $dir;
    Push-Location $dir;

    $portforward1 = Resolve-Path "PortForward\PortForwardKafkaBroker1.ps1";
    $portforward2 = Resolve-Path "PortForward\PortForwardKafkaBroker2.ps1";
    $portforward3 = Resolve-Path "PortForward\PortForwardKafkaBroker3.ps1";
    $portforward4 = Resolve-Path "PortForward\PortForwardZooKeeper.ps1";
    
    Write-Host $portforward1;
    Start-Process -FilePath $command -ArgumentList "-file $portforward1";
    Write-Host $portforward2;
    Start-Process -FilePath $command -ArgumentList "-file $portforward2";
    Write-Host $portforward3;
    Start-Process -FilePath $command -ArgumentList "-file $portforward3";
    Write-Host $portforward4;
    Start-Process -FilePath $command -ArgumentList "-file $portforward4";

    Pop-Location;
}
