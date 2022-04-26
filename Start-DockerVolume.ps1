function Start-DockerVolume {
    <#
    .SYNOPSIS
    Create a new storage volume container
    
    .DESCRIPTION
    This will invoke docker.exe directly to create a new container with the specified container name
    
    .PARAMETER ContainerName
    Parameter The name of the container to be created as a storage volume.
    
    .PARAMETER SourcePath
    Parameter The location on the actual machine the volume will be stored in.
    
    .PARAMETER ContainerPath
    Parameter The path to the volume within the newly created container

    .PARAMETER Image
    Parameter The image to be used for the volume

    .EXAMPLE
    New-DockerVolumne -ContainerName DbData -SourcePath C:\ProgramData\MyApp -ContainerPath /var/lib/my_app -Image alpine
        
    #>

    [cmdletBinding()]
    param(
        [string]$ContainerName = (Read-Host "Please provide a container name" -RawString),
        [string]$SourcePath = (Read-Host "Please provide the source volume path" -RawString),
        [string]$ContainerPath = (Read-Host "Please provide the container path" -RawString),
        [string]$Image = (Read-Host "Please specify the image you want to use" -RawString)
    )
    Write-Host "docker run -d --name $ContainerName --mount source=$SourcePath,target=$ContainerPath $Image;"
    docker run -d --name $ContainerName --mount "source=$SourcePath,target=$ContainerPath" $Image;
}