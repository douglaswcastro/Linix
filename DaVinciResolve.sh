#!/usr/bin/env bash
set -e

# Função de mensagem colorida
msg() { echo -e "\033[1;32m$1\033[0m"; }

msg "🚀 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

msg "📦 Instalando dependências..."
sudo apt install -y \
    libapr1t64 \
    libaprutil1t64 \
    libglib2.0-0t64 \
    ocl-icd-opencl-dev \
    fakeroot \
    xorriso \
    libssl3 \
    libxcb-render0 \
    libxcb-shm0 \
    libxcb-xfixes0 \
    libxkbcommon0 \
    libxrandr2 \
    curl \
    wget \
    unzip

msg "🎵 Verificando biblioteca ALSA..."
if dpkg -l | grep -q libasound2t64; then
    msg "✔ libasound2t64 já está instalado."
elif apt-cache show libasound2t64 &>/dev/null; then
    sudo apt install -y libasound2t64
    msg "✔ libasound2t64 instalado."
else
    msg "⚠ Nenhum pacote ALSA encontrado. Baixando manualmente..."
    wget http://archive.ubuntu.com/ubuntu/pool/main/a/alsa-lib/libasound2t64_1.2.11-1ubuntu3.1_amd64.deb
    sudo apt install ./libasound2t64_1.2.11-1ubuntu3.1_amd64.deb
    rm libasound2t64_1.2.11-1ubuntu3.1_amd64.deb
fi

msg "🌐 Baixando DaVinci Resolve (última versão)..."
DOWNLOAD_URL=$(curl -s https://www.blackmagicdesign.com/api/support/us/downloads | grep -oP 'https://.*DaVinci_Resolve_Studio_[0-9._]+_Linux\.zip' | head -n 1)
if [ -z "$DOWNLOAD_URL" ]; then
    msg "❌ Não foi possível obter o link de download automaticamente."
    exit 1
fi

wget -O davinci_resolve.zip "$DOWNLOAD_URL"

msg "📂 Extraindo instalador..."
unzip -o davinci_resolve.zip -d davinci_tmp
cd davinci_tmp

msg "⚙ Executando instalador..."
sudo ./DaVinci_Resolve_Studio_*_Linux.run

msg "🧹 Limpando arquivos temporários..."
cd ..
rm -rf davinci_tmp davinci_resolve.zip

msg "✅ Instalação concluída!"
