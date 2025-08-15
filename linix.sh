#!/bin/bash

# Autor: Douglas Castro (Atualizado para Ubuntu 24.04 com suporte a Steam)

# CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

# Diretório de Downloads
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

# URLs dos pacotes .deb externos
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_VIVALDI="https://downloads.vivaldi.com/stable/vivaldi-stable_6.7.3329.31-1_amd64.deb"
URL_DAVINCI_RESOLVE="https://www.blackmagicdesign.com/api/support/download/9e0dc87cba8b43c2a4c9b20ec53004c9/Linux"

# URLs e repositórios
URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu"

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
  sudo apt update && sudo apt full-upgrade -y
}

travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock
}

add_archi386(){
  sudo dpkg --add-architecture i386
  sudo apt update
}

onedriver(){
  if command -v onedriver &> /dev/null; then
    echo -e "${VERDE}[INSTALADO] - Onedriver${SEM_COR}"
    return
  fi
  echo "Instalando Onedriver"
  echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
  curl -fsSL https://download.opensuse.org/repositories/home:/jstaf/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
  sudo apt update && sudo apt install -y onedriver
}

code(){
  if command -v code &> /dev/null; then
    echo -e "${VERDE}[INSTALADO] - VSCode${SEM_COR}"
    return
  fi
  echo "Instalando VSCode"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
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
  echo -e "${VERDE}[INFO] - Adicionando repositórios${SEM_COR}"
  sudo add-apt-repository -y ppa:lutris-team/lutris
  sudo add-apt-repository -y ppa:graphics-drivers/ppa

  sudo mkdir -pm755 /etc/apt/keyrings
  wget -O /etc/apt/keyrings/winehq-archive.key "$URL_WINE_KEY"
  sudo wget -NP /etc/apt/sources.list.d/ "$URL_PPA_WINE/dists/noble/winehq-noble.sources"
}

install_debs(){
  echo -e "${VERDE}[INFO] - Baixando e instalando .deb${SEM_COR}"
  mkdir -p "$DIRETORIO_DOWNLOADS"
  
  wget -nc "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
  wget -nc "$URL_VIVALDI" -P "$DIRETORIO_DOWNLOADS"

  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb || sudo apt install -f -y
}

install_flatpaks(){
  echo -e "${VERDE}[INFO] - Instalando Flatpaks${SEM_COR}"
  if ! command -v flatpak &> /dev/null; then
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
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
  if ! snap list | grep -q spotify; then
    sudo snap install spotify
  fi
  if ! snap list | grep -q code; then
    sudo snap install code --classic
  fi
}

install_steam_gaming(){
  echo -e "${VERDE}[INFO] - Instalando suporte a jogos Steam${SEM_COR}"
  sudo apt install -y steam \
    libgl1-mesa-dri:i386 \
    libgl1:i386 \
    libnss3:i386 \
    libstdc++6:i386 \
    libtcmalloc-minimal4:i386 \
    mesa-vulkan-drivers mesa-vulkan-drivers:i386 \
    vulkan-tools

  echo -e "${VERDE}[INFO] - Steam instalada. Ative o Proton nas configurações da Steam.${SEM_COR}"
}

system_clean(){
  echo -e "${VERDE}[INFO] - Limpando sistema${SEM_COR}"
  sudo apt autoremove -y && sudo apt autoclean -y
  flatpak update -y
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
  install_steam_gaming
  davinci_resolve
  system_clean
}

menu_instalador(){
  clear
  echo -e "${VERDE}=========== MENU DE INSTALAÇÃO ===========${SEM_COR}"
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
  echo "11 - Instalar Steam e suporte a jogos"
  echo "12 - Instalar tudo"
  echo "0 - Sair"
  echo "=========================================="

  read -p "Escolha uma opção: " opcao
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
    11) install_steam_gaming;;
    12) instalar_tudo;;
    0) echo -e "${VERDE}Saindo...${SEM_COR}"; exit 0;;
    *) echo -e "${VERMELHO}Opção inválida.${SEM_COR}";;
  esac
}

while true; do
  menu_instalador
  read -p "Pressione Enter para continuar..."
done
