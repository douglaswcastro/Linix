#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   $ ./pos-os-postinstall.sh

echo "Executando pos instalação"

#CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'


# Atualizando repositório e fazendo atualização do sistema

apt_update(){
  echo "Atualizando repositório e fazendo atualização do sistema"
  sudo apt update && sudo apt dist-upgrade -y
}

onedriver(){
  echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
  curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
  sudo apt update
  sudo apt install onedriver
}

code(){
  # vs code
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt update; sudo apt install -y code
}

# Internet conectando?
testes_internet(){
echo "Teste Internet"
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
fi
}

## Removendo travas eventuais do apt ##
travas_apt(){
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

## Adicionando/Confirmando arquitetura de 32 bits ##
add_archi386(){
sudo dpkg --add-architecture i386
}

##DEB SOFTWARES TO INSTALL

PROGRAMAS_PARA_INSTALAR=(
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

sudo apt-add-repository "$PPA_LIBRATBAG" -y
sudo add-apt-repository "$PPA_LUTRIS" -y
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
sudo apt-add-repository "deb $URL_PPA_WINE focal main"

## Download e instalaçao de programas externos ##

## Instalando pacotes Flatpak ##
install_flatpaks(){

  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub org.freedesktop.Piper -y
flatpak install flathub org.chromium.Chromium -y
flatpak install flathub org.gnome.Boxes -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub org.flameshot.Flameshot -y
flatpak install flathub org.electrum.electrum -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub com.getpostman.Postman -y
flatpak install flathub io.github.mimbrero.WhatsAppDesktop -y
flatpak install flathub com.adobe.Flash-Player-Projector -y
}
## Instalando pacotes Snap ##

install_snaps(){
sudo apt install snapd
echo -e "${VERDE}[INFO] - Instalando pacotes snap${SEM_COR}"

sudo snap install authy
sudo snap install pycharm-professional --classic
sudo snap install rider --classic
sudo snap install intellij-idea-ultimate --classic
sudo snap install spotify
sudo snap install obs-studio
#Dotnet 7.0
sudo snap install dotnet-runtime-70
#Dotnet 6.0
sudo snap install dotnet-runtime-60
#Dotnet SDK
sudo snap install dotnet-sdk --classic
#node
sudo snap install node --classic
}

## Finalização, atualização e limpeza##

system_clean(){

apt_update -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
nautilus -q
}

travas_apt
testes_internet
travas_apt
apt_update
travas_apt
add_archi386
just_apt_update
onedriver
code
install_snaps
install_flatpaks
extra_config
apt_update
system_clean

## finalização

echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
