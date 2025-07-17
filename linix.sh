#!/bin/bash

# Autor: Douglas Castro

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

# PPAs e chaves
PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"
PPA_LUTRIS="ppa:lutris-team/lutris"
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"

testes_internet(){
  echo "Teste Internet"
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Sem conexão com a Internet.${SEM_COR}"
    exit 1
  else
    echo -e "${VERDE}[INFO] - Internet OK.${SEM_COR}"
  fi
}

apt_update(){
  echo "Atualizando sistema"
  sudo apt update && sudo apt dist-upgrade -y
}

travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock
}

add_archi386(){
  sudo dpkg --add-architecture i386
}

onedriver(){
  if command -v onedriver &> /dev/null; then
    echo -e "${VERDE}[INSTALADO] - Onedriver${SEM_COR}"
    return
  fi
  echo "Instalando Onedriver"
  echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
  curl -fsSL https://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
  sudo apt update && sudo apt install -y onedriver
}

code(){
  if command -v code &> /dev/null; then
    echo -e "${VERDE}[INSTALADO] - VSCode${SEM_COR}"
    return
  fi
  echo "Instalando VSCode"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  rm -f packages.microsoft.gpg
  sudo apt update && sudo apt install -y code
}

davinci_resolve(){
  echo "Baixando DaVinci Resolve"
  mkdir -p "$DIRETORIO_DOWNLOADS"
  local arquivo_resolve="$DIRETORIO_DOWNLOADS/davinci-resolve.zip"
  if [ ! -f "$arquivo_resolve" ]; then
    wget -O "$arquivo_resolve" "$URL_DAVINCI_RESOLVE"
    echo -e "${VERDE}[INFO] - Extraia e instale manualmente o .run${SEM_COR}"
  else
    echo -e "${VERDE}[INSTALADO] - DaVinci Resolve já baixado${SEM_COR}"
  fi
  nautilus "$DIRETORIO_DOWNLOADS"
}

install_apt_programs(){
  echo -e "${VERDE}[INFO] - Instalando pacotes APT${SEM_COR}"
  local programas=(gparted vlc git gimp thunderbird)
  for programa in "${programas[@]}"; do
    if ! dpkg -l | grep -q "$programa"; then
      sudo apt install -y "$programa"
    else
      echo -e "${VERDE}[INSTALADO] - $programa${SEM_COR}"
    fi
  done
}

add_ppas(){
  echo -e "${VERDE}[INFO] - Adicionando PPAs${SEM_COR}"
  sudo apt-add-repository -y "$PPA_LIBRATBAG"
  sudo add-apt-repository -y "$PPA_LUTRIS"
  sudo apt-add-repository -y "$PPA_GRAPHICS_DRIVERS"
  wget -nc "$URL_WINE_KEY" -O winehq.key
  sudo apt-key add winehq.key
  sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
  sudo apt-add-repository "deb $URL_PPA_WINE focal main"
}

install_debs(){
  echo -e "${VERDE}[INFO] - Instalando .deb${SEM_COR}"
  mkdir -p "$DIRETORIO_DOWNLOADS"
  
  if ! command -v google-chrome &> /dev/null; then
    wget -c "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
  else
    echo -e "${VERDE}[INSTALADO] - Google Chrome${SEM_COR}"
  fi

  if ! command -v vivaldi &> /dev/null; then
    wget -c "$URL_VIVALDI" -P "$DIRETORIO_DOWNLOADS"
  else
    echo -e "${VERDE}[INSTALADO] - Vivaldi${SEM_COR}"
  fi

  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
  sudo apt-get install -f -y
}

install_flatpaks(){
  echo -e "${VERDE}[INFO] - Instalando Flatpaks${SEM_COR}"
  if ! command -v flatpak &> /dev/null; then
    echo -e "${VERMELHO}[ERRO] - Flatpak não instalado.${SEM_COR}"
    return
  fi
  local flatpaks=(org.telegram.desktop com.discordapp.Discord)
  for flatpak in "${flatpaks[@]}"; do
    if ! flatpak list | grep -q "$flatpak"; then
      flatpak install -y flathub "$flatpak"
    else
      echo -e "${VERDE}[INSTALADO] - $flatpak${SEM_COR}"
    fi
  done
}

install_snaps(){
  echo -e "${VERDE}[INFO] - Instalando Snaps${SEM_COR}"
  if ! command -v snap &> /dev/null; then
    sudo apt install -y snapd
  fi
  local snaps=("spotify" "code --classic")
  for snap in "${snaps[@]}"; do
    local snap_name=$(echo "$snap" | cut -d' ' -f1)
    if ! snap list | grep -q "$snap_name"; then
      sudo snap install $snap
    else
      echo -e "${VERDE}[INSTALADO] - $snap_name${SEM_COR}"
    fi
  done
}

system_clean(){
  echo -e "${VERDE}[INFO] - Limpando sistema${SEM_COR}"
  sudo apt update && sudo apt upgrade -y
  flatpak update -y
  sudo apt autoclean -y && sudo apt autoremove -y
  nautilus -q
}

instalar_tudo(){
  travas_apt
  testes_internet
  apt_update
  add_archi386
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

menu_instalador(){
  clear
  echo -e "${VERDE}=========== MENU DE INSTALA\u00c7\u00c3O ===========${SEM_COR}"
  echo "1 - Atualizar sistema"
  echo "2 - Adicionar PPAs"
  echo "3 - Instalar .deb"
  echo "4 - Instalar apt"
  echo "5 - Instalar Flatpak"
  echo "6 - Instalar Snap"
  echo "7 - Onedriver"
  echo "8 - VSCode"
  echo "9 - DaVinci Resolve"
  echo "10 - Limpeza"
  echo "11 - Instalar tudo"
  echo "0 - Sair"
  echo "=========================================="

  read -p "Escolha uma opcao: " opcao
  case $opcao in
    1) travas_apt; testes_internet; apt_update; add_archi386;;
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
    *) echo -e "${VERMELHO}Op\u00e7\u00e3o inv\u00e1lida.${SEM_COR}";;
  esac
}

while true; do
  menu_instalador
  read -p "Pressione Enter para continuar..."
done
echo -e "${VERDE}Obrigado por usar o instalador!${SEM_COR}"
exit 0