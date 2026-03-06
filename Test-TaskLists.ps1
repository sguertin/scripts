function Test-TaskLists {
    $tasksFolder = Get-TaskFolder;
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $morningTaskFile = "$tasksFolder\Morning-$today.tasks"
    $midDayTaskFile = "$tasksFolder\Midday-$today.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$today.tasks"
    $uhOhCounter = 0;
    if ((Test-Path $morningTaskFile) -eq $false) { 
        $uhOhCounter += 1;      
        Write-Warning "Gotta start your morning tasks!"
    }
    $now = Get-Date;
    if (($now.Hour) -ge 12) {
        if ((Test-Path $midDayTaskFile) -eq $false) {
            $uhOhCounter += 1;      
            Write-Warning "Gotta start your midday tasks!"
        }
    }

    if (($now.Hour) -ge 15) {
        if ((Test-Path $endOfDayTaskFile) -eq $false) {
            $uhOhCounter += 1;      
            Write-Warning "Gotta start your end of day tasks!"
        }
    }
    if ($uhOhCounter -gt 1) {
        Write-Error "YOU NEED TO GET YOUR TASKS TOGETHER NOW"
    }
}
Set-Alias -Name taskstatus -Value Test-TaskLists;