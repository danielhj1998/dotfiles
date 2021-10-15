#!/bin/sh
sudo apt update
{{- if (eq .chezmoi.osRelease.id "ubuntu") }}
##sudo apt install vim-gtk3
sudo apt install neovim
{{- else if (eq .chezmoi.osRelease.id "raspbian") }}
# build neovim from source
if [ -f /usr/local/bin/nvim ]; then
    echo "Neovim already installed"
else
    sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
    git clone https://github.com/neovim/neovim
    cd neovim && make -j4
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd ..
    rm -rf neovim
    echo "Neovim installed"
fi
{{- end }}

## node js LTE install with nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm --version
nvm install --lts
npm -g install eslint
npm -g install bash-language-server

sudo apt install python
sudo apt install python3
{{- if (eq .chezmoi.os "linux") }}
{{-   if (.chezmoi.kernel.osrelease | lower | contains "microsoft") }}
{{-      if (eq .chezmoi.osRelease.id "ubuntu") }}
sudo apt install zsh
npm -g install wsl-open
sudo apt install pip
sudo pip install hdl_checker --upgrade
{{-      end }}
{{-   end }}
{{- end }}
