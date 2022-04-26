function Get-UpTimeStamp {
    $uptime = Get-Uptime;

    $days = $uptime.Days
    $hours = $uptime.Hours
    $minutes = $uptime.Minutes
    $seconds = $uptime.Seconds

    Write-Host ("$days" + "d " + "$hours" + "h " + "$minutes" + "m " + "$seconds" + "s")
}