function Start-DatastaxStudio {
    [cmdletBinding()]
    param()

    Write-Host "Starting Datastax studio via C:\datastax-studio-6.7.0\bin\server.bat";
    $task = "C:\datastax-studio-6.7.0\bin\server.bat";

    Start-Process "cmd.exe" "/c $task";
}