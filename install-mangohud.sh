#!/bin/bash

set -e

echo "=== Atualizando sistema ==="
sudo apt update && sudo apt upgrade -y

echo "=== Instalando dependências ==="
sudo apt install -y git cmake python3-mako libx11-dev libxnvctrl-dev \
  libxcomposite-dev libxrandr-dev libxinerama-dev libgl1-mesa-dev \
  libvulkan-dev vulkan-validationlayers-dev libdbus-1-dev ninja-build \
  g++ gcc glslang-tools libpciaccess-dev libyaml-cpp-dev libxext-dev \
  libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev \
  libxcb-randr0-dev libxcb-res0-dev libxcb-util-dev libxcb-xinerama0-dev \
  libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev

echo "=== Clonando repositório do MangoHud ==="
git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
cd MangoHud

echo "=== Compilando MangoHud ==="
./build.sh build
./build.sh install

echo "=== Instalação finalizada com sucesso ==="
echo "Reinicie ou reinicie o Steam/Lutris/etc para aplicar mudanças."
