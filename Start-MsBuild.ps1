function Start-MsBuild {
    [CmdletBinding()]
    param(
        [string]$Solution,
        [string]$Configuration = "Debug"
    )
    if ([System.String]::IsNullOrEmpty($Solution)) {
        $Solution = Read-Host "What solution do you want to build?";
    }
    msbuild $Solution /P:Configuration=$Configuration /v:m /m
}
Set-Alias -Name csbuild -Value Start-MsBuild;