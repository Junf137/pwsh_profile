##############################
# Import Modules
##############################

# Import Modules
Import-Module -Name Save-LatestScreenshot
Import-Module -Name ProcessToDesktop
Import-Module -Name Recycle
Import-Module -Name Posh-Git
Import-Module -Name PSFzf
Import-Module -Name ColoredText
Import-Module -Name Tree

# Using Modules
$ENV:STARSHIP_CONFIG = "$env:USERPROFILE\.config\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# Set Key Bindings
# Clear the text from the start of the current logical line to the cursor. The cleared text is placed in the kill-ring.
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine


##############################
# Variables & Alias
##############################

# variables
# FZF
$ENV:FZF_DEFAULT_OPTS = "--height=60% --layout=reverse --info=inline --border --margin=1 --padding=1"
$ENV:FZF_CTRL_T_OPTS = "--walker-skip .git"

# alias
Set-Alias cl    "clear"

Set-Alias trash     "Remove-ItemSafely"
Set-Alias trestore  "Restore-RecycledItem"
Set-Alias tlist     "Get-RecycledItem"

# convert these aliases to functions
function .. { Set-Location .. }
function ls { Get-ChildItem }
function l { Get-ChildItem }
function rm { Remove-Item }
function rmdir { Remove-Item -Recurse }
function cp { Copy-Item }
function mv { Move-Item }
function cdc { Set-Location C:\ }
function cdd { Set-Location D:\ }
function explorer { Start-Process explorer.exe -ArgumentList "/e, $args" }

##############################
# Initializations
##############################

# sourcing scripts (not recommended)

# welcome message
Get-Content ([System.Environment]::GetFolderPath('MyDocuments') + "\PowerShell\msg\msg_shell_welcome")

##############################
# Function
##############################

# git functions
function gs { git status }
function gcm { git commit }
function gl { git log --decorate=auto --graph --oneline }
function gll { git log --decorate=auto --graph }
function gla { git log --decorate=auto --graph --all --oneline }
function glaa { git log --decorate=auto --graph --all }
function gsl { git stash list }
function gsp { git stash pop }
function gsa { git stash apply }
function gco {
    if ( $args.count -eq 1 ) {
        git checkout $args[0]
    }
}

function New-VmInHeadless {
    param (
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )

    # start the vm
    & "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe" startvm $VmName --type headless
}

function Show-Vms {
    Write-Output "---* All VMs:"
    & "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe" list vms

    Write-Output ""
    Write-Output "---* Running VMs:"
    & "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe" list runningvms
}

function New-VmToNewDesktop {
    param (
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )

    # start the vm
    & "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe" startvm $VmName

    # create a new desktop
    New-Desktop

    Move-ProcessToDesktop -ProcessName "VirtualBoxVM" -DesktopIndex -1
}

# Activate sakuraCat proxy policy
function Start-SakuraProxy {
    $env:http_proxy = "http://127.0.0.1:33210"
    $env:https_proxy = "http://127.0.0.1:33210"
    $env:all_proxy = "socks5://127.0.0.1:33211"
}

# Deactivate sakuraCat proxy policy
function Stop-CurrentProxy {
    $env:http_proxy = ""
    $env:https_proxy = ""
    $env:all_proxy = ""
}

# Show current proxy policy
function Show-CurrentProxy {
    Write-Output "http_proxy: $env:http_proxy"
    Write-Output "https_proxy: $env:https_proxy"
    Write-Output "all_proxy: $env:all_proxy"
}

# activate conda environment
function condaa {
    if ( $args.count -eq 1 ) {
        conda activate $args[0]
    }
    else {
        Write-Output "[Warning]: invalid input, try activating base"
        conda activate base
    }
}


# deactivate current conda environment
function condad { conda deactivate }
