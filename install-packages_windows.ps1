# install neovim
choco install neovim

# install nodejs-lts
choco install nodejs-lts

# install python
choco install python
# install neovim python provider
python -m pip install --user --upgrade pynvim

# install oh-my-posh
choco install oh-my-posh

# install PSReadLine
if (Get-Module -ListAvailable -Name PSReadLine) {
    Write-Host "PSReadLine already exists"
}
else {
    Install-Module -Name PowerShellGet -Force
    Install-Module PSReadLine
}

Exit
