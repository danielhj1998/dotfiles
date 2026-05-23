# ALIAS
set-alias vim nvim
set-alias wc measure-object
set-alias unzip expand-archive
set-alias open invoke-item

function cdnotes
{
    cd 'C:\Users\danielhern\Documents\notes'
}
function grep
{
    [CmdletBinding()]
    param(
        [switch]$r,
        [Parameter(Position=0)]
        [string]$pattern,
        [Parameter(ValueFromPipeline=$true)]
        [string]$path
    )
    process
    {
        if ($r)
        {
            select-string -Pattern $pattern -Path $path
        }
        else
        {
            $path | findstr.exe $pattern
        }
    }
}
function la
{
    ls -force
}

# set vim as default for cmdline and editor
if ($env:TERM_PROGRAM -eq 'vscode') {
    $env:EDITOR = 'vim'
} else {
    Set-Variable -Name EDITOR -Value 'vim' -Scope Global
}

# VI Mode
Set-PSReadlineOption -EditMode Vi

# STARSHIP
$ENV:STARSHIP_CONFIG = "~/.config/starship/starship.toml"
Invoke-Expression (&starship init powershell)

# ZOXIDE
Invoke-Expression (& { (zoxide init powershell | Out-String) })
