function Set-Portrait {
    param (
        [string]$CharacterDirectory = "$PWD",
        [string]$FolderNumber = "",
        [string]$PortraitsFolder = "C:\Users\Scott\AppData\LocalLow\Owlcat Games\Pathfinder Kingmaker\Portraits"
    )
    if ([string]::IsNullOrEmpty($PortraitsFolder)) {
        $PortraitsFolder = Join-Path $env:USERNAME -AdditionalChildPath @("AppData","LocalLow","Owlcat Games","Pathfinder Kingmaker","Portraits")
    }
    if ($CharacterDirectory.Equals("$PWD")) {
        Write-Warning "Command set to run against '$PWD'";
        if (Read-HostPromptToProceed -eq $false) {
            exit 0;
        }
    }
    if ($FolderNumber.Equals("")) {
        Write-Error "A FolderNumber must be specified.";
        exit 1;
    }
    $images = @("FullLength.png", "Medium.png", "Small.png");
    $portraitDirectory = "$PortraitsFolder\$FolderNumber";
    
    foreach($image in $images) {
        $sourcePath = "$portraitDirectory\$image"
        $targetPath = "$CharacterDirectory\$image"
        $quit = $false;
        if ((Test-Path -Path $sourcePath) -ne $true) {
            Write-Error "File Not Found: $sourcePath";
            $quit = $true;
        }
        if ($quit -eq $false) {
            if ((Test-Path -Path $targetPath) -eq $true) {
                Remove-Item -Path $targetPath -Force;
            }
            Write-Host "$sourcePath ===> $targetPath";
            Copy-Item -Path $sourcePath -Destination $targetPath;
        }        
    }
    if ($quit -eq $true) {
        Write-Error "Failed to set portrait.";
        exit 1;
    }
    Write-Host "Character portrait set successfully to $portraitDirectory";
}