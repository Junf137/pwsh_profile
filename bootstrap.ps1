# This script is supposed to be run as Administrator

# Files to link
$sourceFile = @("gitconfig", "vimrc",  "gvimrc", "condarc")
$targetFile = @(".gitconfig", "_vimrc",  "_gvimrc", ".condarc")

# Link files to $env:USERPROFILE
for ($i = 0; $i -lt $sourceFile.Length; $i++) {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath ".\$($sourceFile[$i])"
    $destinationPath = Join-Path -Path $env:USERPROFILE -ChildPath "$($targetFile[$i])"
    New-Item -ItemType SymbolicLink -Path $destinationPath -Target $sourcePath -Force
}
