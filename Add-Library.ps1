function Add-Library {
    param(
        [string]$Path # Path to DLL to be loaded
    ) 
    
    $parentTempDirectory = [System.IO.Path]::GetTempPath()
    
    $childTempDirectory = [System.IO.Path]::GetRandomFileName()
    
    $tempDirectoryPath = Join-Path -Path $parentTempDirectory -ChildPath $childTempDirectory;

    $tempDirectory = New-Item $tempDirectoryPath -ItemType Directory -Force;

    $dll = Get-Item $Path;

    $tempFile = Join-Path -Path $tempDirectory -ChildPath $dll.Name;

    Copy-Item -Path $Path -Destination $tempFile -Force;

    Add-Type -Path $tempFile;
}
