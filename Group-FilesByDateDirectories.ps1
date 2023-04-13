function Group-FilesByDateDirectories {
    [cmdletBinding()]
    param(
        $Directory = $PWD
    )

    Push-Location $Directory;
    $files = Get-ChildItem -File;
    foreach ($file in $files) {
        $dirPath = Join-Path $Directory -ChildPath $file.CreationTime.ToString("MMM-yy");
        if ((Test-Path -Path $dirPath) -eq $false) {
            New-Item -Path $dirPath -ItemType Directory | Out-Null;
            Write-Host "Created $dirPath";
        }
        $destination = Join-Path -Path $dirPath -ChildPath $file.Name;
        Move-Item -Path $file.FullName -Destination $destination | Out-Null;
        Write-Host "$($file.FullName) => $destination";
    }
}
