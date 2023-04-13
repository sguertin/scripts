function Initialize-VirtualEnvironment {
    [CmdletBinding()]
    param(
        [string]$Name = "",
        [string]$Location = $PWD,
        [switch]$NoPrompt = $false
    )
    $locations = @("Scripts", "bin");
    $results = @{};
    foreach ($dir in Get-ChildItem $Location -Directory -Filter $Name) {
        foreach($location in $locations) {
            $activatePath = Join-Path -Path $dir -ChildPath $location -AdditionalChildPath "Activate.ps1";
            if (Test-Path -Path $activatePath) {
                Write-Verbose "Virtual environment detected at '$($dir.Name)'!";
                $results[$dir.Name] = $activatePath;
            }
        }
    }

    if ($results.Count -eq 0) {
        Write-Host "No virtual environment found";
        return;
    }

    if ($results.Count -eq 1 -or $NoPrompt -eq $true) {
        $virtualEnv = $results[$results.Keys[0]];
    } else {
        foreach ($dirName in $results.Keys) {
            $result = Read-Host "Activate virtual environment in $dirName ? [y]es [n]o [q]uit]";
            if ($result.ToLowerInvariant() -eq "y" -or $result.ToLowerInvariant() -eq "yes" ) {
                $virtualEnv = $result[$dirName];
                break;
            } elseif ($result.ToLowerInvariant() -eq "q" -or $result.ToLowerInvariant() -eq "quit") {
                break;
            }
        }
    }
    if ([string]::IsNullOrEmpty($virtualEnv)) {
        Write-Host "No environment selected.";
        return;
    }

    . $virtualEnv;
    return;
}
Set-Alias -Name activate -Value Initialize-VirtualEnvironment;