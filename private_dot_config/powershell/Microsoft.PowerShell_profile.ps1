# ALIAS
set-alias vim nvim
set-alias wc measure-object
set-alias unzip expand-archive
set-alias open invoke-item
set-alias which get-command
set-alias ls eza
set-alias less moor
set-alias rm rip
set-alias cat bat

function bat
{
  & bat.exe --plain $args
}
function la
{
  eza --long --icons --git --all
}
function ltree
{
  eza --tree --level 2 --icons --git
}
Remove-Item Alias:Where -Force -ErrorAction SilentlyContinue
function where
{
  & where.exe $args
}

# BAT
$env:BAT_PAGER="moor"

# set vim as default for cmdline and editor
$ENV:EDITOR = 'nvim'
if ($env:TERM_PROGRAM -eq 'vscode') {
    $env:EDITOR = 'vim'
} else {
    Set-Variable -Name EDITOR -Value 'nvim' -Scope Global
}

# VI Mode
Set-PSReadlineOption -EditMode Vi
# fix escape key from clearin the screen
Remove-PSReadLineKeyHandler -Chord 'Escape' -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Chord 'Escape' -Function ViCommandMode

# Override config location for NVIM
$ENV:XDG_CONFIG_HOME="$HOME/.config"

# YAZI
$ENV:YAZI_CONFIG_HOME="$HOME/.config/yazi"
$ENV:YAZI_FILE_ONE = "/Program Files/Git/usr/bin/file.exe"

# STARSHIP
$ENV:STARSHIP_CONFIG = "~/.config/starship/starship.toml"
Invoke-Expression (&starship init powershell)

# FZF keybindings
$env:FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                -PSReadlineChordReverseHistory 'Ctrl+r'

# ZOXIDE
Invoke-Expression (& { (zoxide init powershell | Out-String) })
