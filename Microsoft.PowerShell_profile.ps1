##############################
# Import Modules
##############################

# Import Modules
Import-Module -Name Save-LatestScreenshot
Import-Module -Name Recycle
Import-Module -Name Posh-Git
Import-Module -Name PSFzf
Import-Module -Name ColoredText
Import-Module -Name Tree


##############################
# Veriables & Alias
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


##############################
# Initializations
##############################

# sourcing scripts (not recommended)

# welsome message
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

# $PATH\VBoxManage.exe startvm "ubuntu2204" --type=headless
function startvm {

    if ( $args.count -eq 1 ) {
        & "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe" startvm $args[0] --type=headless
    }
    else {
        Write-Output "[Log]: Invalid argument number"
    }
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
        Write-Output "[Warning]: invalide input, try activating base"
        conda activate base
    }
}


# deactivate current conda environment
function condad { conda deactivate }
