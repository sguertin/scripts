function Deploy-Files {
    [cmdletBinding()]
    param(
        [string]$SourceDirectory,
        [string]$TargetDirectory
    )
    $backupDirectory = Join-Path $SourceDirectory -ChildPath "backup";
    if (!Test-Path $TargetDirectory) {
        New-Item $TargetDirectory -ItemType Directory;
    }
    if (!Test-Path $backupDirectory) {
        New-Item $backupDirectory -ItemType Directory;
    }
    $sourceFiles = Get-ChildItem $SourceDirectory -Files;
    # Create backups and copy files
    foreach($sourceFile in $sourceFiles) {
        $targetFilePath = Join-Path $TargetDirectory -ChildPath $sourceFile.Name;
        if (Test-Path $targetFilePath) {
            Write-Host "Backing up $targetFilePath to $backupDirectory";
            Copy-Item -Path $targetFilePath -Destination $backupDirectory -Force;
        }
        Write-Host "Copying $($sourceFile.Name) to $TargetDirectory....." -NoNewLine;
        Copy-Item -Path $sourceFile -Destination $TargetDirectory -Force;
        Write-Host "Copy Complete"
    }
}