# This script is supposed to be run as Administrator

# Usage
# .\bootstrap.ps1

# Files to link
$sourceFile = @("gitconfig",
    "vimrc",
    "gvimrc",
    "condarc")

$targetFile = @(".gitconfig",
    "_vimrc",
    "_gvimrc",
    ".condarc")

# Link files to $env:USERPROFILE
for ($i = 0; $i -lt $sourceFile.Length; $i++) {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath ".\$($sourceFile[$i])"
    $destinationPath = Join-Path -Path $env:USERPROFILE -ChildPath "$($targetFile[$i])"

    if (Test-Path $destinationPath) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $newDestinationPath = $destinationPath + "_" + $timestamp
        Rename-Item -Path $destinationPath -NewName $newDestinationPath
    }

    New-Item -ItemType SymbolicLink -Path $destinationPath -Target $sourcePath -Force
}
