function Invoke-UnitTest {
    [CmdletBinding()]
    param(
        [string]$ProjectName,
        [string]$Configuration = "Release",
        [string]$ResultsDirectory = "TestResults"
    )
    # Verify that the dotnet exectuable exists  
    try {
        Get-Command "dotnet" -ErrorAction Stop | Out-Null
    } catch {
        Write-Error "Unable to locate dotnet executable! Quitting";
        return;
    }
    # Create anonymous function to execute unit tests with coverage
    $dotnetTestFn = {
        [CmdletBinding()]
        param(
            [string]$Path,
            [string]$Configuration = "Release",
            [string]$ResultsDirectory = "TestResults"
        )
        Write-Host "dotnet test $Path --configuration $Configuration --results-directory $ResultsDirectory --logger trx /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=$ResultsDirectory/coverage.xml";
        dotnet test $Path --configuration $Configuration --results-directory $ResultsDirectory --logger trx /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput="$ResultsDirectory/coverage.xml"
    }
    # If no project name was specified, search recursively for any csproj files with 'UnitTest' in their name (case insensitive)
    if ([string]::IsNullOrEmpty($ProjectName)) {
        $projects = Get-ChildItem -Rec -Filter "*UnitTest*csproj";

        if ($projects.Length -gt 1) {
            $i = 1;
            $options = @{};
            Write-Host "Multiple Unit Test projects identified within project folders";
            foreach ($project in $projects) {                
                $options[$i.ToString()] = $project;                
                Write-Host ("[$i] - " + (Resolve-Path -Relative -Path $project.FullName));
                $i += 1;
            }
            $userInput = Read-Host "Please select a project [1-$i] or [A]ll, or [N]one";
            
            if ($userInput -eq "N") {
                Write-Host "Exitting...";
            } elseif ($userInput -eq "A") {
                Write-Host "Running all unit tests...";
                foreach ($key in $options.Keys) {                    
                    & $dotnetTestFn -Path $options[$key].FullName -Configuration $Configuration -ResultsDirectory $ResultsDirectory;
                }
            } elseif ($null -ne $options[$userInput.ToString()]) {
                & $dotnetTestFn -Path $options[$userInput].FullName -Configuration $Configuration -ResultsDirectory $ResultsDirectory;
            } else {
                Write-Error "Unrecognized input specified, exitting...";
                return;
            }

        } elseif ($projects.Length -eq 1) {
            $project = $projects[0];
            & $dotnetTestFn -Path $project.FullName -Configuration $Configuration -ResultsDirectory $ResultsDirectory;
        } else {
            Write-Error "Unable to find any projects with 'UnitTest' in their name, please specify a project name or choose a different directory.";
            return;
        }        
    } else { 
        if ($ProjectName.EndsWith("csproj")) {
            $projectFile = $ProjectName;        
        } else {
            $projectFile = "$ProjectName.csproj"
        }
        $projectFiles = Get-ChildItem -Path $PWD -Filter "*csproj" -Recurse;
        foreach($project in $projectFiles) {
            if ($project.Name -eq $projectFile) {
                $foundProject = $True;
                $pathToProject = Resolve-Path project.FullName -Relative;
                break;
            }
        }
        if ($foundProject) {
            & $dotnetTestFn -Path $pathToProject -Configuration $Configuration -ResultsDirectory $ResultsDirectory 
        } else {
            Write-Error "Unable to locate project: $projectFile in $PWD or child directories.";
        }
    }
}