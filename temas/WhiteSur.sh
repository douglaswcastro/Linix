#!/bin/bash

set -e

# Função de instalação de dependências
install_dependencies() {
    sudo apt update
    sudo apt install -y git gnome-tweaks curl wget unzip \
        gnome-shell-extensions chrome-gnome-shell \
        gnome-shell-extension-prefs
}

# Instala tema WhiteSur GTK + Shell
install_whitesur_theme() {
    echo "Instalando tema WhiteSur..."
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
    cd WhiteSur-gtk-theme
    ./install.sh -d ~/.themes -l
    cd ..
    rm -rf WhiteSur-gtk-theme
}

# Instala ícones Tela Circle
install_tela_icons() {
    echo "Instalando ícones Tela Circle..."
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
    cd Tela-circle-icon-theme
    ./install.sh -d ~/.icons
    cd ..
    rm -rf Tela-circle-icon-theme
}

# Instala Capitaine Cursors
install_cursors() {
    echo "Instalando Capitaine Cursors..."
    git clone https://github.com/keeferrourke/capitaine-cursors.git
    cd capitaine-cursors
    ./install.sh -d ~/.icons
    cd ..
    rm -rf capitaine-cursors
}

# Aplica tema e configurações com gsettings
apply_theme() {
    echo "Aplicando tema e configurações..."
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-dark"
    gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-dark"
    gsettings set org.gnome.desktop.interface cursor-theme "Capitaine-cursors"
    gsettings set org.gnome.desktop.interface font-name "Inter 11"
    gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur-dark"
}

# Ativa extensão de User Theme (caso necessário)
enable_user_theme_extension() {
    echo "Ativando extensão User Theme..."
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
}

# Executa tudo
main() {
    install_dependencies
    install_whitesur_theme
    install_tela_icons
    install_cursors
    enable_user_theme_extension
    apply_theme

    echo "✅ Tema aplicado com sucesso! Use o GNOME Tweaks para ajustes finos."
}

main
