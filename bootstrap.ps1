# This script is supposed to be run as Administrator

# Usage
# .\bootstrap.ps1

# Define source and target file mappings
$sourceFiles = @(
    "git\gitconfig",
    "vimfiles",
    "vimfiles",
    "conda\condarc",
    "wezterm\wezterm-config",
    "starship\starship-default"
)

$targetFiles = @(
    ".gitconfig",
    ".vim",
    "vimfiles",
    ".condarc",
    ".config\wezterm\",
    ".config\starship\"
)

# Function to create symbolic links
function New-SymbolicLink {
    param(
        [string]$sourcePath,
        [string]$destinationPath
    )

    try {
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

# Link files to $env:USERPROFILE
for ($i = 0; $i -lt $sourceFiles.Length; $i++) {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath $sourceFiles[$i]
    $destinationPath = Join-Path -Path $env:USERPROFILE -ChildPath $targetFiles[$i]

    # Create symbolic link
    New-SymbolicLink -sourcePath $sourcePath -destinationPath $destinationPath
}
