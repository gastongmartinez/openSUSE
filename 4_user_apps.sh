#!/usr/bin/env bash

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub org.inkscape.Inkscape -y
flatpak --user install flathub com.jetbrains.PyCharm-Community -y
flatpak --user install flathub com.jetbrains.IntelliJ-IDEA-Community -y
flatpak --user install flathub com.google.AndroidStudio -y
flatpak --user install flathub org.kde.krita -y
flatpak --user install flathub org.gimp.GIMP -y
flatpak --user install flathub org.blender.Blender -y
flatpak --user install flathub io.neovim.nvim -y

# Doom Emacs
if [ -d ~/.emacs.d ]; then
    rm -Rf ~/.emacs.d
fi
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

# Anaconda
# wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
# chmod +x Anaconda3-2021.11-Linux-x86_64.sh
# ./Anaconda3-2021.11-Linux-x86_64.sh

# Flutter
if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi
cd ~/Apps || return
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.0-stable.tar.xz
tar xf flutter_linux_3.0.0-stable.tar.xz
rm flutter_linux_3.0.0-stable.tar.xz
cd ~ || return

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir ~/.local/share/zsh
fi
touch ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
{
    echo 'source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme'
    echo 'source /usr/share/autojump/autojump.zsh'
    echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    echo -e '\n# History in cache directory:'
    echo 'HISTSIZE=10000'
    echo 'SAVEHIST=10000'
    echo 'HISTFILE=~/.cache/zshhistory'
    echo 'setopt appendhistory'
    echo 'setopt sharehistory'
    echo 'setopt incappendhistory'
    echo 'JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk'
    echo 'export PATH="$HOME/anaconda3/bin:$HOME/Apps/flutter/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"'
} >>~/.zshrc
chsh -s /usr/bin/zsh

