function New-EndOfDayReport {
    param(
        [DateTime]$Date = (Get-Date)
    )
    $tasksFolder = Get-TaskFolder;   
    $archiveFolder = Join-Path $tasksFolder -ChildPath "archive";
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $morningTaskFile = "$tasksFolder\Morning-$timestamp.tasks"
    $midDayTaskFile = "$tasksFolder\Midday-$timestamp.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$timestamp.tasks"
    $reportFile = "$tasksFolder\Summary-$timestamp.md";
    if (Test-Path $reportFile) {
        Write-Error "'$reportFile' already exists!";
        return;
    }
    if ((Test-Path $morningTaskFile) -eq $false) {
        Write-Error "Unable to find $morningTaskFile, did you forget to create it?";
        return;
    }
    if ((Test-Path $midDayTaskFile) -eq $false) {
        Write-Error "Unable to find $midDayTaskFile, did you forget to create it?";
        return;
    }
    if ((Test-Path $endOfDayTaskFile) -eq $false) {
        Write-Error "Unable to find $endOfDayTaskFile, did you forget to create it?";
        return;
    }
    $reportContent = "# Daily Task Report $timestamp`n`n";
    $reportContent += "## Morning Tasks - $timestamp`n`n";
    $reportContent += (Get-Content $morningTaskFile -Raw);
    $reportContent += "`n`n## Midday Tasks - $timestamp`n`n";
    $reportContent += (Get-Content $midDayTaskFile -Raw);
    $reportContent += "`n`n## End of Day Tasks - $timestamp`n`n";
    $reportContent += (Get-Content $endOfDayTaskFile -Raw);
    $reportContent += "`n";
    Move-Item $morningTaskFile -Destination $archiveFolder;
    Move-Item $midDayTaskFile -Destination $archiveFolder;
    Move-Item $endOfDayTaskFile -Destination $archiveFolder;
    Set-Content -Path $reportFile -Value $reportContent;
    & nano $reportFile;
}
Set-Alias -Name Close -Value New-EndOfDayReport;
Set-Alias -Name CloseDay -Value New-EndOfDayReport;
Set-Alias -Name TaskReport -Value New-EndOfDayReport;
Set-Alias -Name Report -Value New-EndOfDayReport;