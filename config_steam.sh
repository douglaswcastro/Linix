#!/bin/bash
# Script para configurar Steam no Ubuntu 24.04 com suporte a jogos

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
