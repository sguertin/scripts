function Find-ConfigFiles {
    [CmdletBinding()]
    param(
        [Parameter(Position = 1, ValueFromPipeline = $true)][string]$DirectoryPath = $PWD
    )
    begin {
        $extensions = @(".config");
        $excludeDirs = @(".config", "packages", "bin", "obj", ".git", ".terraform", ".nuget", ".build", ".vs", ".vscode", "venv", "scratchpad", "azure-powershell-migration");
        $excludeFiles = @("packages*.config", "NLog.config", "nuget.config", "NLog.build.config")
    }
    process {
        $scanFolders = Get-ChildItem -Path $DirectoryPath -Recurse -Directory | Where-Object { $_.PSIsContainer -and ($_.FullName -notmatch ($excludeDirs -join "|")) };
        foreach ($directory in $scanFolders) {
            foreach ($file in Get-ChildItem -Path $directory.FullName -File | Where-Object { $_.Name -notmatch ($excludeFiles -join "|") }  | Where-Object { $_.Extension.ToLower() -in $extensions }) {
                Write-Output $file;
            }
        }
    }    
}