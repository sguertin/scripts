function Test-PathForChanges {
    [cmdletBinding()]
    param()

    $currentPath = $env:PATH;

    $documentDirectory = Join-Path -Path $env:USERPROFILE -ChildPath "Documents" -AdditionalChildPath @("SystemLogs");

    $pathLogFile = Join-Path $documentDirectory -ChildPath "PathVar.txt";

    if (!(Test-Path $documentDirectory)) {
        Write-Host "No log directory found, creating..." -ForegroundColor Yellow;
        New-Item -Path $documentDirectory -ItemType Directory -Force | Out-Null;
        Set-Content -Path $pathLogFile -Value $currentPath;      
    } elseif (Test-Path $pathLogFile) {
        $oldPathContent = (Get-Content $pathLogFile -Raw).Trim();
        if ($oldPathContent.ToLower() -eq $currentPath.ToLower()) {
            Write-Host "PATH variable matches prior archive" -ForegroundColor Green;
        } else {
            $logFile = Get-Item $pathLogFile;
            $archiveName = ("PathVar-" + ($logFile.LastWriteTime.ToString("yyyy-MM-dd")) + ".txt");                
            if ($oldPathContent.Length -lt $currentPath.Length) {
                Write-Host "PATH variable has been added to since it was last archived." -ForegroundColor Yellow;                
            } elseif ($oldPathContent.Length -gt $currentPath.Length) {
                Write-Host "PATH variable has lost content since it was last archived." -ForegroundColor Red;                
            }
            Write-Host "COPY $pathLogFile =====================> $archiveName";
            Copy-Item $pathLogFile -Destination $archiveName;
            Set-Content -Path $pathLogFile -Value $currentPath;
        }
    } else {
        Write-Host "No log of PATH variable found, creating new log" -ForegroundColor Yellow;
        Set-Content -Path $pathLogFile -Value $currentPath;
    }    
}