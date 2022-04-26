function Get-CustomCommands {
    [CmdletBinding()]
    param()
    $scriptsDirectory = Join-Path $env:USERPROFILE -ChildPath "Scripts";
    $customCommands = Get-ChildItem $scriptsDirectory -Filter "*ps1";
    if ($customCommands.Length -eq 0) {
        Write-Warning "No Custom Commands found in $scriptsDirectory!";
    }
    foreach ($script in $customCommands)
    {
        $fileName = $script.Name.Replace(".ps1", "");
        if ($fileName -ne "SetAliases") {
            Write-host $fileName;
        }
    }
}