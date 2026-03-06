function New-EndOfDayReport {
    param(
        [DateTime]$Date = (Get-Date)
    )
    $tasksFolder = "C:\Users\sguertin\Documents\DailyTasks" ;   
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $morningTaskFile = "$tasksFolder\morning-$timestamp.tasks"
    $midDayTaskFile = "$tasksFolder\midday-$timestamp.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$timestamp.tasks"

    $reportFile = "$tasksFolder\Summary-$timestamp.txt";
    $reportContent = "Morning Tasks - $timestamp`n"
    $reportContent += (Get-Content $morningTaskFile -Raw)
    $reportContent += "`n`nMidday Tasks - $timestamp`n"
    $reportContent += (Get-Content $midDayTaskFile -Raw)
    $reportContent += "`n`nEnd of Day Tasks - $timestamp`n"
    $reportContent += (Get-Content $endOfDayTaskFile -Raw)
    $reportContent += "`n"

    Set-Content -Path $reportFile -Value $reportContent;
}
Set-Alias -Name CloseDay -Value New-EndOfDayReport;
Set-Alias -Name TaskReport -Value New-EndOfDayReport;