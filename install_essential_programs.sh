#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x install_essential_programs.sh
#   $ ./install_essential_programs.sh

echo "Instalando programas essenciais no Ubuntu"

# CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

# Verificando se o sistema está conectado à Internet
testes_internet(){
  echo "Testando conexão com a Internet..."
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
    exit 1
  else
    echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
  fi
}

# Removendo travas eventuais do apt
travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock
}

# Atualizando repositório e sistema
apt_update(){
  echo "Atualizando repositório e sistema"
  sudo apt update && sudo apt dist-upgrade -y
}

# Instalando ferramentas essenciais
install_essentials(){
  echo "Instalando ferramentas essenciais"

  # Programas para instalar
  PROGRAMAS_PARA_INSTALAR=(
    build-essential
    curl
    git
    wget
    vim
    gnome-tweaks
    ubuntu-restricted-extras
    gparted
    synaptic
    vlc
    gnome-sushi
    folder-color
    nodejs
    npm
    gimp
    audacity
    python3
    python3-pip
    openjdk-11-jdk
    docker.io
    docker-compose
    code
    snapd
  )

  # Adicionando repositório do VS Code
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update

  # Instalando programas
  for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
      sudo apt install "$nome_do_programa" -y
    else
      echo "[INSTALADO] - $nome_do_programa"
    fi
  done
}

# Instalando pacotes Snap
install_snaps(){
  echo "Instalando pacotes Snap"
  sudo snap install spotify
  sudo snap install postman
  sudo snap install slack --classic
  sudo snap install discord
  sudo snap install skype --classic
  sudo snap install pycharm-community --classic
  sudo snap install intellij-idea-community --classic
  sudo snap install android-studio --classic
  sudo snap install code --classic
  sudo snap install brave
}

# Configuração extra para Docker
configure_docker(){
  echo "Configurando Docker"
  sudo usermod -aG docker $USER
  newgrp docker
}

# Limpeza do sistema
system_clean(){
  echo -e "${VERDE}[INFO] - Realizando limpeza do sistema${SEM_COR}"
  sudo apt autoclean -y
  sudo apt autoremove -y
}

# Execução das funções
travas_apt
testes_internet
travas_apt
apt_update
travas_apt
install_essentials
install_snaps
configure_docker
system_clean

# Finalização
echo -e "${VERDE}[INFO] - Script finalizado, programas essenciais instalados! :)${SEM_COR}"
