#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x improve-ubuntu.sh
#   $ ./improve-ubuntu.sh

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar utilitários essenciais
echo "Instalando utilitários essenciais..."
sudo apt install -y curl wget git vim gnome-tweaks gnome-shell-extensions

# Habilitar repositório Universe e Multiverse
echo "Habilitando repositórios Universe e Multiverse..."
sudo add-apt-repository universe
sudo add-apt-repository multiverse

# Limpeza do sistema
echo "Limpando pacotes desnecessários..."
sudo apt autoremove -y
sudo apt autoclean -y

# Instalar e configurar firewall UFW
echo "Instalando e configurando firewall UFW..."
sudo apt install -y ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Otimizar o desempenho do sistema
echo "Otimizar o desempenho do sistema..."
sudo apt install -y preload zram-config

# Instalar ferramentas de produtividade
echo "Instalando ferramentas de produtividade..."
sudo apt install -y htop neofetch gnome-sushi

# Configurar Swapiness
echo "Configurando Swapiness..."
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Melhorar o tempo de inicialização
echo "Melhorando o tempo de inicialização..."
sudo systemctl disable NetworkManager-wait-online.service

# Configurar Gnome Tweaks
echo "Configurando Gnome Tweaks..."
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Configurar extensões do GNOME
echo "Instalando e configurando extensões do GNOME..."
gnome-extensions install --force dash-to-dock@micxgx.gmail.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions install --force user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Instalar ferramentas de compressão
echo "Instalando ferramentas de compressão..."
sudo apt install -y zip unzip rar unrar

# Instalar codecs multimídia
echo "Instalando codecs multimídia..."
sudo apt install -y ubuntu-restricted-extras

# Instalar software adicional
echo "Instalando software adicional..."
sudo apt install -y vlc gimp libreoffice

# Configurar o Timeshift para backups
echo "Instalando e configurando Timeshift para backups..."
sudo apt install -y timeshift
sudo timeshift --create --comments "Initial Backup" --tags D

# Instalar gerenciador de pacotes Snap e Flatpak
echo "Instalando Snap e Flatpak..."
sudo apt install -y snapd flatpak

# Configurar o Flatpak
echo "Configurando o Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Melhorias no sistema concluídas! Por favor, reinicie o sistema para aplicar todas as alterações."
