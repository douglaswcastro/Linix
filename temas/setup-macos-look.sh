#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x setup-macos-look.sh
#   ./setup-macos-look.sh

# Atualizar e instalar pacotes necessários
sudo apt update && sudo apt upgrade -y
sudo apt install gnome-tweaks gnome-shell-extensions git wget curl -y

# Adicionar repositório e instalar GNOME Shell Extensions
sudo add-apt-repository universe
sudo apt install gnome-shell-extensions -y

# Instalar temas
THEME_DIR="$HOME/.themes"
ICON_DIR="$HOME/.icons"
mkdir -p $THEME_DIR $ICON_DIR

# Baixar e instalar o tema WhiteSur
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -t all -c dark -c light
cd ..

# Baixar e instalar o pacote de ícones WhiteSur
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh
cd ..

# Baixar e instalar o tema de cursor WhiteSur
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
./install.sh
cd ..

# Instalar fontes
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p $FONT_DIR
cd $FONT_DIR
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
fc-cache -fv
cd -

# Instalar Dash to Dock
gnome-extensions install --force dash-to-dock@micxgx.gmail.com

# Configurar extensões e temas usando gsettings
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-dark'
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 12'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Adicionar hot corner
gnome-extensions enable 'ding@rastersoft.com'

echo "Configuração concluída! Por favor, reinicie a sessão do GNOME para aplicar todas as alterações."
