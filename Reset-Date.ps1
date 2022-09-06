function Reset-Date {
    $URL = "http://api.timezonedb.com/v2.1/get-time-zone?key=JXVVWAJGK0JM&format=json&by=zone&zone=America/New_York";
    $timeInfo = (Invoke-WebRequest -Uri $URL -Method Get).Content | ConvertFrom-Json;    
    $currentDate = Set-Date -Date ([DateTime]::Parse($timeInfo.formatted)); 
    Write-Output ("Date/Time Reset to " + $currentDate.toString("yyyy-MM-dd hh:mm:sstt"));
}