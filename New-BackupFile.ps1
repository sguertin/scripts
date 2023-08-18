function New-BackupFile {
	[cmdletBinding()]
	param(
		[string]$Name,
		[string]$BackupDirectory = $env:BACKUP_DIRECTORY
	)
	if ([string]::IsNullOrEmpty($BackupDirectory)) {
		$BackupDirectory = Read-Host "Please provide a BackupDirectory";
		$env:BACKUP_DIRECTORY = $BackupDirectory;
	}
	Copy-Item $Name -Destination $BackupDirectory;
}