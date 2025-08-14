#!/bin/bash

# Autor: Douglas Castro

# COMO USAR?
#   chmod +x install_dark_themes.sh
#   ./install_dark_themes.sh

echo "Instalando os melhores temas dark no Ubuntu"

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

# Instalando ferramentas necessárias
install_tools(){
  echo "Instalando ferramentas necessárias"
  sudo apt install -y gnome-tweaks gnome-shell-extensions wget unzip
}

# Instalando temas
install_themes(){
  echo "Instalando temas dark"

  # Criar diretórios para temas e ícones
  THEME_DIR="$HOME/.themes"
  ICON_DIR="$HOME/.icons"
  mkdir -p "$THEME_DIR" "$ICON_DIR"

  # URLs dos temas e ícones
  THEME_URLS=(
    "https://github.com/dracula/gtk/archive/refs/heads/master.zip"
    "https://github.com/vinceliuice/Matcha-gtk-theme/archive/refs/heads/master.zip"
    "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/heads/master.zip"
    "https://github.com/vinceliuice/Colloid-gtk-theme/archive/refs/heads/master.zip"
  )
  ICON_URLS=(
    "https://github.com/vinceliuice/Tela-icon-theme/archive/refs/heads/master.zip"
    "https://github.com/horst3180/arc-icon-theme/archive/refs/heads/master.zip"
  )

  # Baixando e instalando temas
  for url in "${THEME_URLS[@]}"; do
    wget -c "$url" -P "$THEME_DIR"
    unzip -o "$THEME_DIR/$(basename "$url")" -d "$THEME_DIR"
  done

  # Baixando e instalando ícones
  for url in "${ICON_URLS[@]}"; do
    wget -c "$url" -P "$ICON_DIR"
    unzip -o "$ICON_DIR/$(basename "$url")" -d "$ICON_DIR"
  done

  # Movendo arquivos descompactados para os diretórios corretos
  mv "$THEME_DIR/gtk-master" "$THEME_DIR/Dracula"
  mv "$THEME_DIR/Matcha-gtk-theme-master" "$THEME_DIR/Matcha"
  mv "$THEME_DIR/WhiteSur-gtk-theme-master" "$THEME_DIR/WhiteSur"
  mv "$THEME_DIR/Colloid-gtk-theme-master" "$THEME_DIR/Colloid"
  mv "$ICON_DIR/Tela-icon-theme-master" "$ICON_DIR/Tela"
  mv "$ICON_DIR/arc-icon-theme-master" "$ICON_DIR/Arc"
}

# Configurando temas e ícones usando GNOME Tweaks
configure_gnome(){
  echo "Configurando temas e ícones com GNOME Tweaks"
  
  # Aplicar tema e ícones usando gsettings (substitua 'Dracula', 'Tela' conforme necessário)
  gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
  gsettings set org.gnome.desktop.interface icon-theme "Tela"
  gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
}

# Limpeza do sistema
system_clean(){
  echo -e "${VERDE}[INFO] - Realizando limpeza do sistema${SEM_COR}"
  sudo apt autoclean -y
  sudo apt autoremove -y
  rm -rf "$THEME_DIR/*.zip" "$ICON_DIR/*.zip"
}

# Execução das funções
travas_apt
testes_internet
travas_apt
apt_update
travas_apt
install_tools
install_themes
configure_gnome
system_clean

# Finalização
echo -e "${VERDE}[INFO] - Script finalizado, temas dark instalados e configurados! :)${SEM_COR}"
