##############################
# Import Modules
##############################

# Import Modules
Import-Module -Name Save-LatestScreenshot


##############################
# Veriables & Alias
##############################

# variables
$PWSH_PROFILE_PATH = "$env:USERPROFILE\Documents\PowerShell"
$VIM = "D:\ProgramFiles\Vim"
$VIMRUNTIME = "$VIM\vim90"

# alias
Set-Alias vim_t "$VIMRUNTIME\vim.exe"
Set-Alias vim   "$VIMRUNTIME\gvim.exe"

Set-Alias cl   	"clear"

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
Get-Content "$PWSH_PROFILE_PATH\msg\msg_shell_welcome"

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
    Set-Location "D:\ProgramFiles\Oracle\VirtualBox"

    if ( $args.count -eq 1 ) {
        .\VBoxManage.exe startvm $args[0] --type=headless
    }
    else {
        Write-Output "[Log]: Invalid argument number"
    }
}

# activate sakuraCat proxy policy
function actProxy {
    $env:http_proxy = "http://127.0.0.1:33210"
    $env:https_proxy = "http://127.0.0.1:33210"
    $env:all_proxy = "socks5://127.0.0.1:33211"
}

# deactivate sakuraCat proxy policy
function deactProxy {
    $env:http_proxy = ""
    $env:https_proxy = ""
    $env:all_proxy = ""
}

# show current proxy policy
function showProxy {
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
