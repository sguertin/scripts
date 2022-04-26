function Get-HoursLogged {
    [CmdletBinding()]
    param(
        [DateTime]$Date = [DateTime]::Now
    )
    $homeDirectory = $env:USERPROFILE;
    $year = $Date.Year;
    $month = $Date.Month;
    $day = $Date.Day;
    $filePath = "$homeDirectory\TimeTracking\TimeTracking-$year-$month-$day.log"
    return Get-Content $filePath;
}