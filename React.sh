#!/bin/bash

# Atualizar e atualizar pacotes do sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências essenciais
sudo apt install -y curl git build-essential libssl-dev

# Instalar Node.js (usando NVM - Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Verificar instalação do Node.js e NPM
node -v
npm -v

# Instalar Yarn
npm install -g yarn

# Instalar OpenJDK 11
sudo apt install -y openjdk-11-jdk

# Verificar instalação do Java
java -version

# Configurar variável de ambiente JAVA_HOME
echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

# Instalar Android SDK e ferramentas necessárias
sudo apt install -y unzip

# Baixar e instalar SDK Manager da Android Command Line Tools
mkdir -p ~/Android/cmdline-tools
cd ~/Android/cmdline-tools
curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools.zip
rm commandlinetools.zip
mv cmdline-tools latest
mv latest cmdline-tools
export ANDROID_HOME=$HOME/Android
export PATH=$ANDROID_HOME/cmdline-tools/cmdline-tools/bin:$PATH
source ~/.bashrc

# Instalar pacotes do Android SDK necessários
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" "extras;google;google_play_services" "extras;google;m2repository" "extras;android;m2repository"

# Adicionar Android SDK ao PATH
echo "export ANDROID_HOME=$HOME/Android" >> ~/.bashrc
echo "export PATH=\$ANDROID_HOME/emulator:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools/bin:\$ANDROID_HOME/platform-tools:\$PATH" >> ~/.bashrc
source ~/.bashrc

# Instalar React Native CLI
npm install -g react-native-cli

# Verificar as instalações
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Yarn: $(yarn -v)"
echo "Java: $(java -version)"
echo "React Native CLI: $(react-native -v)"
echo "Android SDK: $ANDROID_HOME"

echo "Configuração concluída. Reinicie o terminal ou execute 'source ~/.bashrc' para aplicar todas as configurações."
