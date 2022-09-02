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
    foreach($sourecFile in $sourceFiles) {
        $fileName = $sourecFile.Name;
        $targetFilePath = Join-Path $TargetDirectory -ChildPath $fileName;
        if (Test-Path $targetFilePath) {
            Write-Host "Backing up $targetFilePath to $backupDirectory";
            Copy-Item -Path $targetFilePath -Destination $backupDirectory -Force;
        }
        Write-Host "Copying $fileName to $TargetDirectory....." -NoNewLine;
        Copy-Item -Path $sourecFile -Destination $TargetDirectory -Force;
        Write-Host "Copy Complete"
    }
}