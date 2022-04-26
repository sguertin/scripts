function New-WorkLog {
    param(
        [DateTime]$Date = [DateTime]::Now
    )
    $Year = $Date.Year.ToString().PadLeft(4,"0");;
    $Month = $Date.Month.ToString().PadLeft(2, "0");
    $Day = $Date.Day.ToString().PadLeft(2, "0");
    $fileName = "WorkLog-$Year-$Month-$Day.md";    
    $workLogDirectory = Join-Path $env:USERPROFILE -ChildPath "Documents" -AdditionalChildPath @("WorkLogs");    
    $newFile = Join-Path $workLogDirectory -ChildPath "$fileName";
    Write-Host "Checking for $newFile"
    if (Test-Path $newFile) {
        Write-Error "$newFile already created!";
        return $newFile;
    }
    $templateWorkLog = Join-Path $workLogDirectory -ChildPath "WorkLog-YYYY-MM-DD.md";
    Copy-Item $templateWorkLog -Destination $newFile;
    Set-Content $newFile -Value ((Get-Content $newFile).Replace("YYYY", $Year).Replace("MM", $Month).Replace("DD", $Day));
    Write-Host "New WorkLog file has been created: $newFile";
    return $newFile
}