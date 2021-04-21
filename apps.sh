#!/bin/bash

rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
zypper refresh

PAQUETES=(
    #### Compresion ####
    'file-roller'
    'p7zip'
    'unrar'
    'unzip'
    'zip'
    
    #### Fuentes ####
    'terminus-bitmap-fonts'
    'dejavu-fonts'
    'powerline-fonts'
    'ubuntu-fonts'
    'fontawesome-fonts'
    'saja-cascadia-code-fonts'
    
    #### WEB ####
    'wget'
    'curl'
    'chromium'
    'MozillaThunderbird'
    'remmina'
    'qbittorrent'
       
    #### Terminales ####
    'alacritty'
    
    #### Shells ####
    'fish'
    'zsh'
    'alacritty-bash-completion'
    'alacritty-fish-completion'
    'alacritty-zsh-completion'

    #### Archivos ####
    'fd'
    'mc'
    'vifm'  
    'meld'
    'stow'
    'ripgrep'
    'fuse-exfat'

    #### Sistema ####
    'conky'
    'ntp'  
    'htop'
    'neofetch'
    'lshw'

    #### Editores ####
    'emacs'
    'neovim'
    'code'

    #### Multimedia ####
    'clementine'
    'mpv'

    #### Juegos ####
    'chromium-bsu'
    
    #### Redes ####
    'nmapsi4'
    'wireshark-ui-qt'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'
    'FreeCAD'
  
    # Dev
    'git'
    'go'
    'clang'
    'rust'
    'filezilla'
    'codeblocks'
    'python3'
    'python39'
    #'java-11-openjdk'
    'java-15-openjdk'
    #'ghc'
    #'cabal-install'

    # KDE
    'kcron'
    'krusader'
    'krusader-doc'
    'knotes'
    'kfind'
    'kalarm'
    'dolphin-plugins'
    'yakuake'
    'kmymoney'
    'kruler'
    'kcolorchooser'
    'ktouch'
    'kalgebra'
    'cantor'
    'kdiff3'
    'kdevelop5'
    'latte-dock'

    # Xmonad
    #'xmonad'
    #'ghc-xmonad'
    #'ghc-xmonad-contrib'
    #'xmobar'
    #'ghc-xmobar'
    
    # Qtile
    'qtile'
    'rofi'
    'powerline'
    'dmenu'
    'nitrogen'
)

for PAQ in "${PAQUETES[@]}"; do
    zypper install -y "$PAQ"
done
