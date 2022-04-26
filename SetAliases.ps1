Set-Alias -Name datetime -Value Get-Date;
Set-Alias -Name mountas -Value New-Mount;
Set-Alias -Name ln -Value New-SymLink;
Set-Alias -Name zip -Value Compress-Archive;
if ((Test-Path -Path "C:\Bin\kubectl.exe") -eq $true) {
    Set-Alias -Name kubectl -Value C:\Bin\kubectl.exe;
    Set-Alias -Name kube -Value C:\Bin\kubectl.exe;
}
if (Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe") {
    Set-Alias -Name msbuild -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"    
}
Set-Alias -Name which -Value Get-CommandExt;