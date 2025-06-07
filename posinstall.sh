#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x posinstall.sh
#   ./posinstall.sh

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
URL_VIVALDI="https://downloads.vivaldi.com/stable/vivaldi-stable_6.7.3329.31-1_amd64.deb"
URL_DAVINCI_RESOLVE="https://www.blackmagicdesign.com/api/support/download/9e0dc87cba8b43c2a4c9b20ec53004c9/Linux"

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

# Removendo travas eventuais do apt
travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock
}

# Adicionando/Confirmando arquitetura de 32 bits
add_archi386(){
  sudo dpkg --add-architecture i386
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

# Instalando DaVinci Resolve
davinci_resolve(){
  echo "Baixando e iniciando instalação do DaVinci Resolve"
  mkdir -p "$DIRETORIO_DOWNLOADS"
  local arquivo_resolve="$DIRETORIO_DOWNLOADS/davinci-resolve.zip"
  wget -O "$arquivo_resolve" "$URL_DAVINCI_RESOLVE"
  echo -e "${VERDE}[INFO] - DaVinci Resolve baixado. Extraia e instale manualmente via script .run.${SEM_COR}"
  nautilus "$DIRETORIO_DOWNLOADS"
}

# Instalando programas do repositório APT
install_apt_programs(){
  echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

  local programas=(
    winff virtualbox ratbagd gparted timeshift gufw synaptic solaar
    vlc gnome-sushi folder-color git wget ubuntu-restricted-extras
    nodejs npm gimp audacity lutris libvulkan1 libvulkan1:i386
    libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386
    libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386
    libdbus-1-3:i386 libsqlite3-0:i386 opencl-headers ocl-icd-libopencl1
    clinfo flameshot qbittorrent transmission keepassxc thunderbird
    kazam simplescreenrecorder obs-studio ffmpeg filezilla remmina
    chromium-browser docker.io docker-compose podman
    openjdk-17-jdk maven mysql-server postgresql postgresql-contrib
    papirus-icon-theme gnome-shell-extensions gnome-shell-extension-manager
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
  wget -c "$URL_VIVALDI" -P "$DIRETORIO_DOWNLOADS"

  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
  sudo apt-get install -f -y
}

# Instalando pacotes Flatpak
install_flatpaks(){
  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

  if ! command -v flatpak &> /dev/null; then
    echo -e "${VERMELHO}[ERRO] - Flatpak não está instalado. Pule a opção 5 do menu ou instale-o com 'sudo apt install flatpak'.${SEM_COR}"
    return
  fi

  local flatpaks=(
    com.bitwarden.desktop org.telegram.desktop org.freedesktop.Piper
    org.chromium.Chromium org.gnome.Boxes org.onlyoffice.desktopeditors
    org.qbittorrent.qBittorrent org.flameshot.Flameshot org.electrum.electrum
    com.discordapp.Discord com.brave.Browser com.getpostman.Postman
    io.github.mimbrero.WhatsAppDesktop com.adobe.Flash-Player-Projector
    com.heroicgameslauncher.hgl net.ankiweb.Anki org.libreoffice.LibreOffice
    org.dropbox.Dropbox net.cozic.joplin_desktop
  )

  for flatpak in "${flatpaks[@]}"; do
    flatpak install -y flathub "$flatpak"
  done
}

# Instalando pacotes Snap
install_snaps(){
  echo -e "${VERDE}[INFO] - Instalando pacotes snap${SEM_COR}"

  if ! command -v snap &> /dev/null; then
    sudo apt install -y snapd
  fi

  local snaps=(
    "authy"
    "pycharm-professional --classic"
    "rider --classic"
    "intellij-idea-ultimate --classic"
    "spotify"
    "obs-studio"
    "dotnet-runtime-80"
    "dotnet-runtime-70"
    "dotnet-runtime-60"
    "dotnet-sdk --classic"
    "node --classic"
  )

  for snap in "${snaps[@]}"; do
    sudo snap install $snap
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

# Instalar tudo
instalar_tudo(){
  travas_apt
  testes_internet
  travas_apt
  apt_update
  travas_apt
  add_archi386
  apt_update
  add_ppas
  install_debs
  install_apt_programs
  install_flatpaks
  install_snaps
  onedriver
  code
  davinci_resolve
  system_clean
}

# Menu interativo
menu_instalador(){
  clear
  echo -e "${VERDE}=========== MENU DE INSTALAÇÃO ===========${SEM_COR}"
  echo "1 - Atualizar sistema e preparar apt"
  echo "2 - Adicionar PPAs"
  echo "3 - Instalar pacotes .deb"
  echo "4 - Instalar pacotes apt"
  echo "5 - Instalar pacotes Flatpak"
  echo "6 - Instalar pacotes Snap"
  echo "7 - Instalar Onedriver"
  echo "8 - Instalar VSCode"
  echo "9 - Instalar DaVinci Resolve"
  echo "10 - Limpeza do sistema"
  echo "11 - Instalar tudo (completo)"
  echo "0 - Sair"
  echo "=========================================="

  read -p "Escolha uma opção: " opcao
  case $opcao in
    1) travas_apt; testes_internet; travas_apt; apt_update; travas_apt; add_archi386; apt_update;;
    2) add_ppas;;
    3) install_debs;;
    4) install_apt_programs;;
    5) install_flatpaks;;
    6) install_snaps;;
    7) onedriver;;
    8) code;;
    9) davinci_resolve;;
    10) system_clean;;
    11) instalar_tudo;;
    0) echo -e "${VERDE}Saindo...${SEM_COR}"; exit 0;;
    *) echo -e "${VERMELHO}Opção inválida.${SEM_COR}";;
  esac
}

# Loop do menu
while true; do
  menu_instalador
  read -p "Pressione Enter para continuar..."
done
