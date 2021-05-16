#!/bin/bash

pkill packagekitd

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

read -rp "Desea establecer el password para root? (S/N): " PR
if [ "$PR" == 'S' ]; 
then
    passwd root
fi

read -rp "Desea corregir la resolucion en VMWare Workstation? (S/N): " RES
if [ "$RES" == 'S' ]; 
then
    cp /etc/vmware-tools/tools.conf.example /etc/vmware-tools/tools.conf
    sed -i 's/#enable=true/enable=true/g' "/etc/vmware-tools/tools.conf"
    systemctl restart vmtoolsd.service
fi

read -rp "Desea establecer el nombre del equipo? (S/N): " HN
if [ "$HN" == 'S' ]; 
then
    read -rp "Ingrese el nombre del equipo: " EQUIPO
    if [ -n "$EQUIPO" ]; 
    then
        echo -e "$EQUIPO" > /etc/hostname
    fi
fi

pkill packagekitd
zypper dup -y

systemctl enable sshd

# Ajuste Swappiness
su - root <<EOF
        echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf
EOF

rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
zypper refresh

################################ Apps Generales #################################
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
    'google-roboto-fonts'
    'google-roboto-mono-fonts'
    'google-roboto-slab-fonts'
    'fetchmsttfonts'
    'iosevka-fonts'
    'iosevka-slab-fonts'

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
    'ShellCheck'
    'autojump'

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
    'flameshot'
    'ktouch'

    #### Editores ####
    'emacs'
    'neovim'
    'code'

    #### Multimedia ####
    'clementine'
    'mpv'
    'vlc'

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
    'python39-pip'
    'nodejs15'
    'npm15'
    'java-1_8_0-openjdk'
    #'java-15-openjdk'
    #'ghc'
    #'cabal-install'  
)
for PAQ in "${PAQUETES[@]}"; do
    zypper install -y "$PAQ"
done
#################################################################################

################################## KDE ##########################################
read -rp "Instalar KDE Apps? (S/N): " KDE
if [ "$KDE" == 'S' ]; then
    KDEAPPS=(
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
        'kalgebra'
        'cantor'
        'kdiff3'
        'kdevelop5'
        'latte-dock'
    )
    for PAQ in "${KDEAPPS[@]}"; do
        zypper install -y "$PAQ"
    done
fi
#################################################################################

############################### Virtualizacion ##################################
read -rp "Instalar virtualizacion? (S/N): " VIRT
if [ "$VIRT" == 'S' ]; then
    VAPPS=(
        'virt-manager'
        'qemu'
        'qemu-extra'
        'vde2'
        'bridge-utils'
        'virtualbox'
        'virtualbox-guest-tools'
        'virtualbox-guest-x11'
    )
    for PAQ in "${VAPPS[@]}"; do
        zypper install -y "$PAQ"
    done
fi
#################################################################################

########################### Awesome #############################################
read -rp "Instalar AwesomeWM? (S/N): " AW
if [ "$AW" == 'S' ]; then
    AWPAQ=(
        'awesome'
        'awesome-branding-openSUSE'
        'rofi'
        'powerline'
        'dmenu'
        'nitrogen'       
        'feh'
        'picom'
        'lxappearance'
    )
    for PAQ in "${AWPAQ[@]}"; do
        zypper install -y "$PAQ"
    done
    sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"
fi
#################################################################################

######################## Extensiones Gnome ######################################    
read -rp "Instalar Extensiones Gnome? (S/N): " EXT
if [ "$EXT" == 'S' ]; then
    zypper install -y gnome-shell-extension-pop-shell
    zypper install -y gnome-shell-extension-user-theme
    zypper install -y gnome-shell-extensions-common
    zypper install -y gnome-shell-extensions-common-lang
    HOMEDIR=$(grep "1000" /etc/passwd | awk -F : '{ print $6 }')
    USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
    PWD=$(pwd)
    for ARCHIVO in "$PWD"/Extensiones/*.zip
    do
        UUID=$(unzip -c "$ARCHIVO" metadata.json | grep uuid | cut -d \" -f4)
        mkdir -p "$HOMEDIR"/.local/share/gnome-shell/extensions/"$UUID"
        unzip -q "$ARCHIVO" -d "$HOMEDIR"/.local/share/gnome-shell/extensions/"$UUID"/
    done
    chown -R "$USER":users "$HOMEDIR"/.local/
fi
#################################################################################




