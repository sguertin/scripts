function Reset-Date {
    $time = New-WebServiceProxy http://www.satan.lt/WebServices/Time.asmx; 
    $currentDate = Set-Date -Date ($time.GetServerLocalTime()); 
    Write-Output "Date/Time Reset to " + $currentDate.toString("yyyy-MM-dd hh:mm:sstt");
}