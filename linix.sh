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

# Verificar e instalar Zenity se necessário
install_zenity(){
  if ! command -v zenity &> /dev/null; then
    echo "Instalando Zenity para interface gráfica..."
    sudo apt update && sudo apt install -y zenity
  fi
}

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

install_custom_deb(){
  install_zenity
  arquivo=$(zenity --file-selection --title="Selecione o arquivo .deb para instalar" --file-filter="*.deb" --width=600)
  if [ $? -eq 0 ] && [ -n "$arquivo" ]; then
    echo "Instalando $arquivo..."
    sudo dpkg -i "$arquivo" || sudo apt install -f -y
    zenity --info --text="Instalação concluída!" --width=300
  else
    zenity --error --text="Nenhum arquivo selecionado." --width=300
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

improve_ubuntu(){
  echo "Atualizando o sistema..."
  sudo apt update && sudo apt upgrade -y

  echo "Instalando utilitários essenciais..."
  sudo apt install -y curl wget git vim gnome-tweaks gnome-shell-extensions

  echo "Habilitando repositórios Universe e Multiverse..."
  sudo add-apt-repository universe
  sudo add-apt-repository multiverse

  echo "Limpando pacotes desnecessários..."
  sudo apt autoremove -y
  sudo apt autoclean -y

  echo "Instalando e configurando firewall UFW..."
  sudo apt install -y ufw
  sudo ufw enable
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  echo "Otimizando o desempenho do sistema..."
  sudo apt install -y preload zram-config

  echo "Instalando ferramentas de produtividade..."
  sudo apt install -y htop neofetch gnome-sushi

  echo "Configurando Swapiness..."
  sudo sysctl vm.swappiness=10
  echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

  echo "Melhorando o tempo de inicialização..."
  sudo systemctl disable NetworkManager-wait-online.service

  echo "Configurando Gnome Tweaks..."
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

  echo "Instalando e configurando extensões do GNOME..."
  gnome-extensions install --force dash-to-dock@micxgx.gmail.com
  gnome-extensions enable dash-to-dock@micxgx.gmail.com
  gnome-extensions install --force user-theme@gnome-shell-extensions.gcampax.github.com
  gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

  echo "Instalando ferramentas de compressão..."
  sudo apt install -y zip unzip rar unrar

  echo "Instalando codecs multimídia..."
  sudo apt install -y ubuntu-restricted-extras

  echo "Instalando software adicional..."
  sudo apt install -y vlc gimp libreoffice

  echo "Instalando e configurando Timeshift para backups..."
  sudo apt install -y timeshift
  sudo timeshift --create --comments "Initial Backup" --tags D

  echo "Instalando Snap e Flatpak..."
  sudo apt install -y snapd flatpak

  echo "Configurando o Flatpak..."
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  echo "Melhorias no sistema concluídas! Por favor, reinicie o sistema para aplicar todas as alterações."
}

install_essential_programs(){
  echo "Instalando programas essenciais no Ubuntu"

  # Verificando se o sistema está conectado à Internet
  testes_internet

  # Removendo travas eventuais do apt
  travas_apt

  # Atualizando repositório e sistema
  apt_update

  # Instalando ferramentas essenciais
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
    if ! dpkg -l | grep -q $nome_do_programa; then
      sudo apt install "$nome_do_programa" -y
    else
      echo "[INSTALADO] - $nome_do_programa"
    fi
  done

  # Instalando pacotes Snap
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

  # Configuração extra para Docker
  echo "Configurando Docker"
  sudo usermod -aG docker $USER
  newgrp docker

  # Limpeza do sistema
  system_clean

  echo "[INFO] - Script finalizado, programas essenciais instalados! :)"
}

install_dark_themes(){
  echo "Instalando os melhores temas dark no Ubuntu"

  # Verificando se o sistema está conectado à Internet
  testes_internet

  # Removendo travas eventuais do apt
  travas_apt

  # Atualizando repositório e sistema
  apt_update

  # Instalando ferramentas necessárias
  echo "Instalando ferramentas necessárias"
  sudo apt install -y gnome-tweaks gnome-shell-extensions wget unzip

  # Instalando temas
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

  # Configurando temas e ícones usando GNOME Tweaks
  echo "Configurando temas e ícones com GNOME Tweaks"
  
  # Aplicar tema e ícones usando gsettings (substitua 'Dracula', 'Tela' conforme necessário)
  gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
  gsettings set org.gnome.desktop.interface icon-theme "Tela"
  gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

  # Limpeza do sistema
  system_clean
  rm -rf "$THEME_DIR/*.zip" "$ICON_DIR/*.zip"

  echo "[INFO] - Script finalizado, temas dark instalados e configurados! :)"
}

config_steam(){
  echo "===== Configurando suporte a jogos Steam no Ubuntu ====="

  # 1️⃣ Ativar suporte a 32 bits
  echo "[1/6] Ativando arquitetura i386..."
  sudo dpkg --add-architecture i386
  sudo apt update

  # 2️⃣ Instalar Steam oficial
  echo "[2/6] Instalando Steam..."
  sudo apt install -y steam

  # 3️⃣ Instalar drivers Vulkan e bibliotecas 32 bits
  echo "[3/6] Instalando bibliotecas e drivers Vulkan..."
  sudo apt install -y \
      mesa-vulkan-drivers mesa-vulkan-drivers:i386 \
      libgl1-mesa-dri libgl1-mesa-dri:i386 \
      libnss3 libnss3:i386 \
      libstdc++6 libstdc++6:i386 \
      libtcmalloc-minimal4:i386 \
      libx11-6:i386 libx11-xcb1:i386 libxcb1:i386 \
      libxext6:i386 libxdamage1:i386 libxfixes3:i386 \
      libxrandr2:i386 libxinerama1:i386 libxi6:i386

  # 4️⃣ Detectar e instalar driver NVIDIA se necessário
  echo "[4/6] Verificando drivers NVIDIA..."
  if lspci | grep -i nvidia > /dev/null; then
      echo "NVIDIA detectada. Instalando drivers recomendados..."
      sudo ubuntu-drivers autoinstall
  fi

  # 5️⃣ Criar atalho para rodar Steam pelo terminal
  echo "[5/6] Criando alias para debug da Steam..."
  if ! grep -q "alias steam-debug" ~/.bashrc; then
      echo "alias steam-debug='steam'" >> ~/.bashrc
  fi

  # 6️⃣ Mensagem final
  echo "[6/6] Configuração concluída!"
  echo "Agora abra a Steam, vá em Configurações > Compatibilidade e ative o Proton Experimental."
  echo "Se algum jogo não rodar, use 'steam-debug' no terminal para ver os erros."

  echo "===== Tudo pronto! ====="
}

install_amdgpu(){
  echo "=== Atualizando sistema ==="
  sudo apt update && sudo apt upgrade -y

  echo "=== Instalando dependências ==="
  sudo apt install -y wget curl gnupg lsb-release software-properties-common

  UBUNTU_VERSION=$(lsb_release -rs)
  echo "Detectado Ubuntu $UBUNTU_VERSION"

  echo "=== Adicionando repositório oficial da AMD ==="
  wget https://repo.radeon.com/amdgpu-install/6.1/ubuntu/${UBUNTU_VERSION}/amdgpu-install_6.1.60100-1_all.deb

  echo "=== Instalando pacote de instalação AMDGPU ==="
  sudo dpkg -i amdgpu-install_6.1.60100-1_all.deb
  sudo apt update

  echo "=== Instalando driver AMDGPU ==="
  # Para instalar driver completo (OpenCL + Vulkan + Mesa)
  sudo amdgpu-install -y --usecase=graphics,opencl

  echo "=== Finalizado. Reinicie o sistema para aplicar mudanças. ==="
}

install_mangohud(){
  echo "Instalando MangoHud para monitoramento de desempenho em jogos"

  # Adicionar repositório
  sudo add-apt-repository -y ppa:flexiondotorg/mangohud
  sudo apt update

  # Instalar MangoHud
  sudo apt install -y mangohud

  echo "MangoHud instalado. Para usar, execute jogos com 'mangohud jogo' ou configure no Steam."
}

config_zsh(){
  echo "Configurando ZSH como shell padrão"

  # Instalar ZSH
  sudo apt install -y zsh

  # Instalar Oh My Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Instalar plugins populares
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # Configurar .zshrc
  sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

  # Definir ZSH como shell padrão
  chsh -s $(which zsh)

  echo "ZSH configurado. Reinicie o terminal ou faça logout/login para aplicar."
}

install_dev_environment(){
  echo -e "${VERDE}[INFO] - Instalando ambiente de desenvolvimento completo${SEM_COR}"
  
  # Ferramentas básicas
  sudo apt install -y build-essential git curl wget
  
  # Python
  sudo apt install -y python3 python3-pip python3-venv
  
  # Node.js e npm (usando NodeSource PPA para versão LTS)
  if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
  fi
  
  # Java (OpenJDK)
  sudo apt install -y openjdk-17-jdk
  
  # Docker
  if ! command -v docker &> /dev/null; then
    sudo apt install -y ca-certificates gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
  fi
  
  # GitHub CLI
  if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh
  fi
  
  # VS Code (já tem função code)
  code
  
  # Outras ferramentas
  sudo apt install -y vim htop tree
  
  echo -e "${VERDE}[INFO] - Ambiente de desenvolvimento instalado. Reinicie o terminal para aplicar mudanças no Docker.${SEM_COR}"
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
  echo "13 - Melhorar Ubuntu"
  echo "14 - Instalar programas essenciais"
  echo "15 - Instalar temas dark"
  echo "16 - Configurar Steam"
  echo "17 - Instalar AMD GPU"
  echo "18 - Instalar MangoHud"
  echo "19 - Configurar ZSH"
  echo "20 - Instalar .deb personalizado"
  echo "21 - Instalar ambiente de desenvolvimento completo"
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
    13) improve_ubuntu;;
    14) install_essential_programs;;
    15) install_dark_themes;;
    16) config_steam;;
    17) install_amdgpu;;
    18) install_mangohud;;
    19) config_zsh;;
    20) install_custom_deb;;
    21) install_dev_environment;;
    0) echo -e "${VERDE}Saindo...${SEM_COR}"; exit 0;;
    *) echo -e "${VERMELHO}Opção inválida.${SEM_COR}";;
  esac
}

menu_grafico(){
  install_zenity
  selecionados=$(zenity --checklist \
    --title="Instalador Linix - Interface Gráfica" \
    --text="Selecione as opções para instalar:" \
    --column="Marcar" \
    --column="Opção" \
    FALSE "Atualizar sistema" \
    FALSE "Adicionar PPAs" \
    FALSE "Instalar .deb" \
    FALSE "Instalar apt" \
    FALSE "Instalar Flatpak" \
    FALSE "Instalar Snap" \
    FALSE "Onedriver" \
    FALSE "VSCode" \
    FALSE "DaVinci Resolve" \
    FALSE "Limpeza" \
    FALSE "Instalar Steam e suporte a jogos" \
    FALSE "Melhorar Ubuntu" \
    FALSE "Instalar programas essenciais" \
    FALSE "Instalar temas dark" \
    FALSE "Configurar Steam" \
    FALSE "Instalar AMD GPU" \
    FALSE "Instalar MangoHud" \
    FALSE "Configurar ZSH" \
    FALSE "Instalar .deb personalizado" \
    FALSE "Instalar ambiente de desenvolvimento completo" \
    --separator="|" \
    --width=500 \
    --height=600)

  if [ $? -eq 1 ]; then
    echo -e "${VERDE}Cancelado.${SEM_COR}"
    exit 0
  fi

  IFS='|' read -ra OPCOES <<< "$selecionados"

  for opcao in "${OPCOES[@]}"; do
    case $opcao in
      "Atualizar sistema") travas_apt; testes_internet; apt_update; add_archi386;;
      "Adicionar PPAs") add_ppas;;
      "Instalar .deb") install_debs;;
      "Instalar apt") install_apt_programs;;
      "Instalar Flatpak") install_flatpaks;;
      "Instalar Snap") install_snaps;;
      "Onedriver") onedriver;;
      "VSCode") code;;
      "DaVinci Resolve") davinci_resolve;;
      "Limpeza") system_clean;;
      "Instalar Steam e suporte a jogos") install_steam_gaming;;
      "Melhorar Ubuntu") improve_ubuntu;;
      "Instalar programas essenciais") install_essential_programs;;
      "Instalar temas dark") install_dark_themes;;
      "Configurar Steam") config_steam;;
      "Instalar AMD GPU") install_amdgpu;;
      "Instalar MangoHud") install_mangohud;;
      "Configurar ZSH") config_zsh;;
      "Instalar .deb personalizado") install_custom_deb;;
      "Instalar ambiente de desenvolvimento completo") install_dev_environment;;
    esac
  done

  zenity --info --text="Instalação concluída!" --width=300
}

while true; do
  if command -v zenity &> /dev/null && [ -n "$DISPLAY" ]; then
    if zenity --question --text="Deseja usar a interface gráfica?" --width=300; then
      menu_grafico
    else
      menu_instalador
    fi
  else
    menu_instalador
  fi
  read -p "Pressione Enter para continuar..."
done

while true; do
  menu_instalador
  read -p "Pressione Enter para continuar..."
done
