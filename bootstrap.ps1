# This script is supposed to be run as Administrator

# Usage
# .\bootstrap.ps1

# Define source and target file mappings
# Format: @{ Source = "relative/path/from/script"; Target = "target/path"; BaseDir = "ENV_VAR" }
# If BaseDir is specified, Target will be joined with the value of that environment variable
# If BaseDir is not specified, Target is treated as an absolute path
$linkMappings = @(
    @{ Source = "git\gitconfig"; Target = ".gitconfig"; BaseDir = "USERPROFILE" },
    @{ Source = "vimfiles"; Target = ".vim"; BaseDir = "USERPROFILE" },
    @{ Source = "vimfiles"; Target = "vimfiles"; BaseDir = "USERPROFILE" },
    @{ Source = "conda\condarc"; Target = ".condarc"; BaseDir = "USERPROFILE" },
    @{ Source = "wezterm\wezterm-config"; Target = ".config\wezterm"; BaseDir = "USERPROFILE" },
    @{ Source = "starship\starship-default"; Target = ".config\starship"; BaseDir = "USERPROFILE" },
    @{ Source = "scoop"; Target = ".config\scoop"; BaseDir = "USERPROFILE" }
)

# Function to create symbolic links
function New-SymbolicLink {
    param(
        [string]$sourcePath,
        [string]$destinationPath
    )

    try {
        # Create parent directory if it doesn't exist
        $destinationDir = Split-Path -Path $destinationPath -Parent
        if (!(Test-Path -Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            Write-Verbose "Created directory: $destinationDir"
        }

        if (Test-Path $destinationPath) {
            # Backup or remove existing item
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $newDestinationPath = "$destinationPath.$timestamp"

            # Backup existing file
            Rename-Item -Path $destinationPath -NewName $newDestinationPath -ErrorAction Stop
            Write-Verbose "Backed up existing file: $destinationPath -> $newDestinationPath"
        }

        # Create symbolic link
        New-Item -ItemType SymbolicLink -Path $destinationPath -Target $sourcePath -Force -ErrorAction Stop
        Write-Output "Created symbolic link: $destinationPath -> $sourcePath"
    }
    catch {
        Write-Error "Error occurred: $_"
    }
}

# Process all symbolic links
foreach ($mapping in $linkMappings) {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath $mapping.Source

    # Determine the destination path based on whether BaseDir is specified
    if ($mapping.BaseDir) {
        $baseDir = [Environment]::GetEnvironmentVariable($mapping.BaseDir)
        $destinationPath = Join-Path -Path $baseDir -ChildPath $mapping.Target
    }
    else {
        $destinationPath = $mapping.Target
    }

    # Create symbolic link
    New-SymbolicLink -sourcePath $sourcePath -destinationPath $destinationPath
}
