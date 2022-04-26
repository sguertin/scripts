function Switch-PowerBuilderEnvironment {
    [CmdletBinding(DefaultParameterSetName='Production')]
    param(
        [Parameter(ParameterSetName='Development', Mandatory=$False)]
        [switch]$Development,
        [Parameter(ParameterSetName='Hotfix', Mandatory=$False)]
        [switch]$Hotfix,
        [Parameter(ParameterSetName='Production', Mandatory=$False)]
        [switch]$Production,
        [Parameter(ParameterSetName='QA', Mandatory=$False)]
        [switch]$QA,
        [Parameter(ParameterSetName='UAT', Mandatory=$False)]
        [switch]$UAT,
        [string]$WorkingDirectory = ""
    )
    $environments = @{
        'Development'='HAI02D-SQLLEG01'
        'HotFix'='HAI01U-SQLLEG01\HOTFIX'
        'QA'='HAI02D-SQLLEG01\QA'
        'Production'='HAI02P-SQLLEG01' 
        'UAT'= 'HAI01U-SQLLEG01'
        'LegacyProduction'='SQLPROD'
        'LegacyTest'='SQLTEST'
    }
    $configFile = "PBAPPL.INI";
    $sourceDirectory = $env:PowerBuilderSource;
    if ([string]::IsNullOrEmpty($WorkingDirectory) -eq $false) {
        $sourceDirectory = $WorkingDirectory;
        [Environment]::SetEnvironmentVariable("PowerBuilderSource", $WorkingDirectory, 'Machine')
    }
    if ([string]::IsNullOrEmpty($sourceDirectory)) {
        $sourceDirectory = Read-Host "Please provide the path to your PB Checkout";
        [Environment]::SetEnvironmentVariable("PowerBuilderSource", $sourceDirectory, 'Machine')
    }
    $sourceDirectoryExists = Test-Path $sourceDirectory;
    if ($sourceDirectoryExists -eq $false) {
        Write-Error "Unable to locate $sourceDirectory!";
        return;
    }
    $configFilePath = Join-Path $sourceDirectory -ChildPath $configFile;
    if ((Test-Path $configFilePath) -eq $false) {
        Write-Error "Unable to locate $configFilePath!";
        return;
    }
    $DatabaseName = [string]::Empty;
    $envName = $PsCmdlet.ParameterSetName
    if (!$environments.ContainsKey($envName)) {
        Write-Error "$envName is not a valid environment type"
        return;
    }
    $DatabaseName = $environments[$envName];    
    $configContent = Get-Content $configFilePath -Raw;
    $newContent = [string]::Empty;
    foreach($environment in $environments.Keys) {
        $newContent = $configContent.Replace($environments[$environment], $DatabaseName);
        if ($newContent -ne $configContent) {
            $backupPath = $configFilePath.Replace(".INI", ".$environment.INI.bak");
            break;
        }
    }    
    if (($newContent -notcontains $DatabaseName)) {
        Write-Warning "An error may have occurred during the update as $DatabaseName is not found in $configFilePath after running the update.";
        return;
    } 
    elseif ($newContent -eq $configContent) {
        Write-Warning "WARNING: No changes were made to $configFilePath"
        return;
    }     
    Write-Host "Backing up $configFilePath to $backupPath";
    Copy-Item $configFilePath -Destination $backupPath -Force; # overwrite previous backup
    Write-Host "Updating $configFilePath to point at $DatabaseName";
    Set-Content $configFilePath -Value $newContent;
    Write-Host "Finished switching to $DatabaseName";

    
}
Set-Alias -Name pbswitch -Value Switch-PowerBuilderEnvironment;