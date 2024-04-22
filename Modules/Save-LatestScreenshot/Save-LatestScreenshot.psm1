# Function to save a file with a dialog in PowerShell
function Save-FileWithDialog {
    param (
        [string]$FilePath
    )

    # Add assembly for OpenFileDialog
    Add-Type -AssemblyName System.Windows.Forms

    # Create SaveFileDialog object
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog

    # Set properties for the SaveFileDialog
    $saveFileDialog.Filter = "All files (*.*)|*.*"
    $saveFileDialog.Title = "Save File As"
    $saveFileDialog.FileName = [System.IO.Path]::GetFileName($FilePath)

    # Show the SaveFileDialog and check if user clicked OK
    if ($saveFileDialog.ShowDialog() -eq 'OK') {
        # Get the selected file path
        $savePath = $saveFileDialog.FileName

        # Perform actions with the selected file path
        Copy-Item -Path $FilePath -Destination $savePath -Force
        Write-Host "File saved to: $savePath"
    } else {
        Write-Host "File save operation cancelled."
    }
}

# Function to save the latest screenshot with dialog
function Save-LatestScreenshot {
    param (
        [string]$ScreenPath = "$env:USERPROFILE\Pictures\Screenshots"
    )

    # Find the latest screenshot
    $latestScreenshot = Get-ChildItem -Path $ScreenPath | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1

    # Save the latest screenshot with dialog
    Save-FileWithDialog -FilePath $latestScreenshot.FullName
}
