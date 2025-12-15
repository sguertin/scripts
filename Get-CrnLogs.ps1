function Get-CrnLogs {
    param()
    $logsDirectory = "\\as1\Applications\Prod\ODEN\Logs"
    $Today = Get-Date;
    $year = $Today.Year;
    $month = $Today.Month;
    $day = $Today.Day;
    $newLogFilePath = "$logsDirectory\CrnLoaderResponseErrors-$year-$month-$day.txt";
    if (Test-Path "$logsDirectory\CrnLoaderResponseErrors-$year-$month-$day.txt") {
        Write-Host "Error file found for today's CRN Load: $newLogFilePath" -ForegroundColor Red;
    }
}