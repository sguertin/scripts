function Get-UpTimeStamp {
    $uptime = Get-Uptime;
    Write-Host "$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m $($uptime.Seconds)s"
}