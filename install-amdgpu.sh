#!/bin/bash

set -e

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
