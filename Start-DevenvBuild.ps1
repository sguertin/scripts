function Start-DevenvBuild {
    [CmdletBinding()]
    param(
        $SlnPath = "$PWD\Promail.sln",
        $Configuration = "Debug"
    )
    $StartTime = [System.DateTime]::Now;
    Write-Host "devenv.com $SlnPath /Build $Configuration /Out $PWD\devenv-errors.log";
    devenv.com $SlnPath /Build $Configuration /Out "$PWD\devenv-errors.log";
    $EndTime = [System.DateTime]::Now;
    $TimeElapsed = ($EndTime - $StartTime).TotalSeconds
    $TimeElapsedMinutes = ($TimeElapsed/60);

    Write-Host "Build finished in $TimeElapsedMinutes Minutes";
}