function New-PortraitGallery {
    param(
        [string]$TargetDirectory = $PWD,
        [string]$PortraitsDirectory = "$PWD\Portraits"
    )
    $galleryPath = "$TargetDirectory\PortraitGallery";
    
    if ((Test-Path $galleryPath) -eq $True) {
        Write-Warning "Gallery already exists! Previous links will be overwritten if you proceed!"
        [string]$Option = Read-Host -Prompt "Do you wish to continue? Y/N";
        if ($Option.ToLower().Equals("n")) {
            Write-Host "Quitting...";
            exit 0
        } elseif ($Option.ToLower().Equals("y")) {
            Write-Warning "Continuing with Gallery Creation"
        } else {
            Write-Error "That's not 'Y' or 'N' so I'm quitting anyways";
            exit 1;
        }
    } else {
        New-Item $galleryPath -ItemType Directory;
    }

    $portraitFolders = Get-ChildItem $PortraitsDirectory -Directory;
    foreach($folder in $portraitFolders) {        
        $folderName = $folder.Name;
        $folderPath = $folder.FullName;
        if ($folderName.Length -lt 5) {
            New-Item -Path "$galleryPath\$folderName.png" -ItemType SymbolicLink -Value "$folderPath\FullLength.png";
        } else {
            Write-Warning "Game Folder '$folderName' skipped."
        }        
    }
}