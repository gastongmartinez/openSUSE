#!/bin/bash

pkill packagekitd
systemctl disable --now packagekit

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
firewall-cmd --zone=public --permanent --add-service=ssh

# Ajuste Swappiness
su - root <<EOF
        echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf
EOF

rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
zypper addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
zypper refresh

################################ Apps Generales #################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'powertop'

    #### KDE ####
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
    'ktouch'
    'cantor'
    'kdiff3'
    'kdevelop5'
    'latte-dock'
    
    #### WEB ####
    'chromium'
    'MozillaThunderbird'
    'remmina'
    'qbittorrent'
    'brave-browser'

    #### Terminales ####
    'alacritty'

    #### Shells ####
    'zsh'
    'alacritty-bash-completion'
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
    'unrar'
    'conky'
    'ntp'  
    'htop'
    'neofetch'
    'lshw'
    'flameshot'
    'xdpyinfo'
    'the_silver_searcher'
    'fzf'
    'aspell'
    'powerline'
    'foliate'
    'pandoc'
    'file-roller'
    'zip'
    
    #### Multimedia ####
    'mpv'

    #### Editores ####
    'emacs'
    'code'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'
    'retroarch-assets'

    #### Redes ####
    'nmap'
    'nmapsi4'
    'wireshark-ui-qt'
    'firewall-config'
    'firewall-applet'    
      
    #### Fuentes ####
    'terminus-bitmap-fonts'
    'powerline-fonts'
    'ubuntu-fonts'
    'fontawesome-fonts'
    'saja-cascadia-code-fonts'
    'google-roboto-mono-fonts'
    'fetchmsttfonts'
    'google-caladea-fonts'
  
    #### Dev ####
    'git'
    'go'
    'clang'
    'cmake'
    'meson'
    'rust'
    'cargo'
    'filezilla'
    'nodejs16'
    'npm16'
    'yarn'
    'java-1_8_0-openjdk'
    'gcc-c++'
    #'java-15-openjdk'

    #### PostgreSQL ####
    'postgresql-server'
    'postgresql-plpython'
    'pgadmin4'
    'pgadmin4-web-uwsgi'
)
for PAQ in "${PAQUETES[@]}"; do
    zypper install -y "$PAQ"
done
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

################################ Wallpapers #####################################
read -rp "Instalar Wallpapers? (S/N): " WPP
if [ "$WPP" == 'S' ]; then
    echo -e "\nInstalando wallpapers..."
    git clone https://github.com/gastongmartinez/wallpapers.git
    mv -f wallpapers/ "/usr/share/backgrounds/"
fi
#################################################################################
