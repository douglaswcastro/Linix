#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x posinstall.sh
#   $ ./posinstall.sh

echo "Executando pós-instalação"

# CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

# Diretório de Downloads
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

# URLs dos pacotes .deb externos
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.18.5-1_amd64.deb"
URL_INSYNC="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.7.0.50216-impish_amd64.deb"
URL_SYNOLOGY_DRIVE="https://global.download.synology.com/download/Utility/SynologyDriveClient/2.0.3-11105/Ubuntu/Installer/x86_64/synology-drive-client-11105.x86_64.deb"

# PPAs e URLs das chaves
PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"
PPA_LUTRIS="ppa:lutris-team/lutris"
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"

# Teste de conexão com a Internet
testes_internet(){
  echo "Teste Internet"
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
    exit 1
  else
    echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
  fi
}

# Atualizando repositório e fazendo atualização do sistema
apt_update(){
  echo "Atualizando repositório e fazendo atualização do sistema"
  sudo apt update && sudo apt dist-upgrade -y
}

# Instalando Onedriver
onedriver(){
  echo "Instalando Onedriver"
  echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
  curl -fsSL https://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
  sudo apt update
  sudo apt install -y onedriver
}

# Instalando Visual Studio Code
code(){
  echo "Instalando Visual Studio Code"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update
  sudo apt install -y code
}

# Removendo travas eventuais do apt
travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock
}

# Adicionando/Confirmando arquitetura de 32 bits
add_archi386(){
  sudo dpkg --add-architecture i386
}

# Instalando programas do repositório APT
install_apt_programs(){
  echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

  local programas=(
    winff
    virtualbox
    ratbagd
    gparted
    timeshift
    gufw
    synaptic
    solaar
    vlc
    gnome-sushi
    folder-color
    git
    wget
    ubuntu-restricted-extras
    nodejs
    npm
    gimp
    audacity
    lutris
    libvulkan1
    libvulkan1:i386
    libgnutls30:i386
    libldap-2.4-2:i386
    libgpg-error0:i386
    libxml2:i386
    libasound2-plugins:i386
    libsdl2-2.0-0:i386
    libfreetype6:i386
    libdbus-1-3:i386
    libsqlite3-0:i386
    opencl-headers
    ocl-icd-libopencl1
    clinfo
  )

  for programa in "${programas[@]}"; do
    if ! dpkg -l | grep -q "$programa"; then
      sudo apt install -y "$programa"
    else
      echo "[INSTALADO] - $programa"
    fi
  done
}

# Adicionando PPAs e instalando chaves
add_ppas(){
  echo -e "${VERDE}[INFO] - Adicionando PPAs e instalando chaves${SEM_COR}"
  
  sudo apt-add-repository -y "$PPA_LIBRATBAG"
  sudo add-apt-repository -y "$PPA_LUTRIS"
  sudo apt-add-repository -y "$PPA_GRAPHICS_DRIVERS"
  wget -nc "$URL_WINE_KEY" -O winehq.key
  sudo apt-key add winehq.key
  sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
  sudo apt-add-repository "deb $URL_PPA_WINE focal main"
}

# Download e instalação de pacotes .deb externos
install_debs(){
  echo -e "${VERDE}[INFO] - Baixando e instalando pacotes .deb${SEM_COR}"

  mkdir -p "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_INSYNC" -P "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_SYNOLOGY_DRIVE" -P "$DIRETORIO_DOWNLOADS"

  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
  sudo apt-get install -f -y
}

# Instalando pacotes Flatpak
install_flatpaks(){
  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

  local flatpaks=(
    com.bitwarden.desktop
    org.telegram.desktop
    org.freedesktop.Piper
    org.chromium.Chromium
    org.gnome.Boxes
    org.onlyoffice.desktopeditors
    org.qbittorrent.qBittorrent
    org.flameshot.Flameshot
    org.electrum.electrum
    com.discordapp.Discord
    com.brave.Browser
    com.getpostman.Postman
    io.github.mimbrero.WhatsAppDesktop
    com.adobe.Flash-Player-Projector
  )

  for flatpak in "${flatpaks[@]}"; do
    flatpak install -y flathub "$flatpak"
  done
}

# Instalando pacotes Snap
install_snaps(){
  echo -e "${VERDE}[INFO] - Instalando pacotes snap${SEM_COR}"

  sudo apt install -y snapd

  local snaps=(
    authy
    pycharm-professional --classic
    rider --classic
    intellij-idea-ultimate --classic
    spotify
    obs-studio
    dotnet-runtime-80
    dotnet-runtime-70
    dotnet-runtime-60
    dotnet-sdk --classic
    node --classic
  )

  for snap in "${snaps[@]}"; do
    sudo snap install "$snap"
  done
}

# Limpeza do sistema
system_clean(){
  echo -e "${VERDE}[INFO] - Realizando limpeza do sistema${SEM_COR}"
  
  sudo apt update
  sudo apt upgrade -y
  flatpak update -y
  sudo apt autoclean -y
  sudo apt autoremove -y
  nautilus -q
}

# Execução das funções
travas_apt
testes_internet
travas_apt
apt_update
travas_apt
add_archi386
apt_update
onedriver
code
add_ppas
install_debs
install_apt_programs
install_snaps
install_flatpaks
system_clean

# Finalização
echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
