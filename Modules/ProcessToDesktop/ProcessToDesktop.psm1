

<#
.SYNOPSIS
    Retrieves the main window handle of a specified process.

.DESCRIPTION
    The Get-ProcessWindowHandle function takes a process name as a parameter, checks if the process exists and if it has a main window handle.
    If all checks pass, it returns the window handle of the process.

.PARAMETER ProcessName
    The name of the process whose window handle is to be retrieved.

.OUTPUTS
    System.IntPtr

.EXAMPLE
    Get-ProcessWindowHandle -ProcessName "notepad"

    This command retrieves the window handle of the Notepad process.

.NOTES
    The function returns early and throws an error if the process does not exist or does not have a main window handle.
#>
function Get-ProcessWindowHandle {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ProcessName
    )

    # Check if the process exists
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-Error "Process $ProcessName not found."
        return
    }

    # Check if the process has a main window handle
    $process_Hwnd = $process.MainWindowHandle
    if (-not $process_Hwnd) {
        Write-Error "Process $ProcessName does not have a main window handle."
        return
    }

    return $process_Hwnd
}


<#
.SYNOPSIS
    Moves a window to a specified desktop.

.DESCRIPTION
    The Move-WindowHandleToDesktop function takes a window handle and an optional desktop index as parameters.
    If the desktop index is not provided, it moves the window to the current desktop.
    If the index is -1, it moves the window to the last desktop.

.PARAMETER WindowHandle
    The handle of the window to be moved.

.PARAMETER DesktopIndex
    The index of the desktop to move the window to. If not provided, the window is moved to the current desktop.
    If the index is -1, the window is moved to the last desktop.

.EXAMPLE
    Move-WindowHandleToDesktop -WindowHandle 123456 -DesktopIndex 2

    This command moves the window with handle 123456 to the desktop with index 2.

.NOTES
    The function uses the Get-CurrentDesktop, Get-DesktopList, Get-Desktop, and Move-Window functions,
    which should be defined elsewhere in your script or module.
#>
function Move-WindowHandleToDesktop {
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$WindowHandle,

        [Parameter(Mandatory = $false)]
        [int]$DesktopIndex
    )

    # Get the current desktop if no index is provided
    if (-not $PSBoundParameters.ContainsKey('DesktopIndex')) {
        $DesktopIndex = (Get-CurrentDesktop).Index
    }

    # Get the last desktop if the index is -1
    if ($DesktopIndex -eq -1) {
        # Use Get-DesktopCount
        $DesktopIndex = (Get-DesktopList).Count - 1
    }

    # Get the desktop
    $desktop = Get-Desktop -Index $DesktopIndex

    # Move each window in the WindowHandle array to the desktop
    foreach ($handle in $WindowHandle) {

        # hadle not 0
        if ($handle -eq 0) {
            continue
        }

        Move-Window -Desktop $desktop -Hwnd $handle
    }
}


<#
.SYNOPSIS
    Moves a specified process to a desktop.

.DESCRIPTION
    The Move-ProcessToDesktop function takes a process name and an optional desktop index as parameters.
    It retrieves the window handle of the process and moves it to the specified desktop.
    If the desktop index is not provided, it moves the process to the current desktop.
    If the index is -1, it moves the process to the last desktop.

.PARAMETER ProcessName
    The name of the process to be moved.

.PARAMETER DesktopIndex
    The index of the desktop to move the process to. If not provided, the process is moved to the current desktop.
    If the index is -1, the process is moved to the last desktop.

.EXAMPLE
    Move-ProcessToDesktop -ProcessName "notepad" -DesktopIndex 2

    This command moves the Notepad process to the desktop with index 2.

.NOTES
    The function uses the Get-ProcessWindowHandle and Move-WindowHandleToDesktop functions,
    which should be defined elsewhere in your script or module.
#>
function Move-ProcessToDesktop {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ProcessName,

        [Parameter(Mandatory = $false)]
        [int]$DesktopIndex
    )

    $process_Hwnd = Get-ProcessWindowHandle -ProcessName $ProcessName

    Move-WindowHandleToDesktop -WindowHandle $process_Hwnd -DesktopIndex $DesktopIndex
}
