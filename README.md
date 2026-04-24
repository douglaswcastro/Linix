# 🐧 LINIX

Script de pós-instalação para distribuições baseadas em Ubuntu. Automatiza a instalação de programas essenciais, PPAs, Flatpaks, Snaps, temas, configurações e muito mais. Ideal para quem acabou de formatar o sistema e quer tudo pronto em poucos minutos.

---

## 🚀 Funcionalidades

- ✅ Verificação de conexão com a internet
- ✅ Correção de travas do APT
- ✅ Adição de arquitetura i386
- ✅ Instalação de pacotes `.deb`, `apt`, `flatpak` e `snap`
- ✅ Adição de repositórios PPA
- ✅ Instalação de programas como:
  - Google Chrome
  - Visual Studio Code
  - Onedriver
  - DaVinci Resolve (manual)
  - VLC, GIMP, Thunderbird, Git, etc.
- ✅ Instalação de temas dark e ícones
- ✅ Configuração de Steam para jogos
- ✅ Instalação de drivers AMD GPU
- ✅ Instalação de MangoHud
- ✅ Configuração de ZSH com Oh My Zsh
- ✅ Ambiente de desenvolvimento completo (Python, Node.js, Java, Docker, etc.)
- ✅ **Interface gráfica** com Zenity para seleção fácil de opções
- ✅ Menu interativo textual para execução por etapas
- ✅ Verificação de pacotes já instalados para evitar duplicações
- ✅ **Todos os scripts centralizados** em um único arquivo executável

---

## 📦 Requisitos

- Ubuntu 22.04 ou superior
- Acesso root (sudo)
- Conexão com a internet
- Zenity (instalado automaticamente se necessário)

---

## 🛠️ Como usar

```bash
# Clone o repositório
git clone https://github.com/douglaswcastro/linix.git

# Acesse a pasta
cd linix

# Dê permissão de execução
chmod +x linix.sh

# Execute o script
./linix.sh
```

O script detectará automaticamente se você está em um ambiente gráfico e oferecerá a interface gráfica com Zenity. Nela, você pode marcar múltiplas opções para instalar simultaneamente.

---

## 🖥️ Interface Gráfica

Se Zenity estiver disponível e você estiver em um ambiente gráfico (DISPLAY definido), o script perguntará se deseja usar a interface gráfica. Nela, você pode marcar múltiplas opções para instalar simultaneamente.

---

## 🧠 Observações

- O DaVinci Resolve requer extração e instalação manual após o download.
- Alguns drivers (como NVIDIA) podem requerer reinicialização.
- O script instala automaticamente o Zenity se necessário.

Flatpaks e Snaps precisam que seus respectivos gerenciadores estejam instalados.

Caso você utilize outra versão do Ubuntu, edite as URLs e comandos conforme necessário.

---

## 🤝 Contribuições
Pull Requests e sugestões são bem-vindas! Sinta-se à vontade para abrir uma Issue com ideias, bugs ou melhorias.

---

📜 Licença
Este projeto está licenciado sob a MIT License.