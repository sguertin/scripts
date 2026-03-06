function New-EndOfDayReport {
    param(
        [DateTime]$Date = (Get-Date)
    )
    $tasksFolder = Get-TaskFolder;   
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $morningTaskFile = "$tasksFolder\Morning-$timestamp.tasks"
    $midDayTaskFile = "$tasksFolder\Midday-$timestamp.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$timestamp.tasks"

    $reportFile = "$tasksFolder\Summary-$timestamp.txt";
    $reportContent = "## Morning Tasks - $timestamp`n"
    $reportContent += (Get-Content $morningTaskFile -Raw)
    $reportContent += "`n`n## Midday Tasks - $timestamp`n"
    $reportContent += (Get-Content $midDayTaskFile -Raw)
    $reportContent += "`n`n## End of Day Tasks - $timestamp`n"
    $reportContent += (Get-Content $endOfDayTaskFile -Raw)
    $reportContent += "`n"

    Set-Content -Path $reportFile -Value $reportContent;
    & nano $reportFile;
}
Set-Alias -Name CloseDay -Value New-EndOfDayReport;
Set-Alias -Name TaskReport -Value New-EndOfDayReport;