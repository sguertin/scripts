function Install-PipPackage {
	[cmdletbinding()]
	param(
		[string]$PackageName,
		[switch]$User = $false,
		[switch]$Global = $false,
		[switch]$Upgrade = $false
	)
	if ([string]::IsNullOrEmpty($PackageName)) {
		Write-Error "No package name provided!";
		return $false;
	}
	$command = "python -m pip install";

	if ($User) {
		$command += " --user";
	}
	if ($Global) {
		$command += " --global";
	}
	if ($Upgrade) {
		$command += " --upgrade";
	}
	$command += " $PackageName"
	Write-Host $command;

	/bin/bash -c $command;	
}
