# 🐧 LINIX

Script de pós-instalação para distribuições baseadas em Ubuntu. Automatiza a instalação de programas essenciais, PPAs, Flatpaks, Snaps, e muito mais. Ideal para quem acabou de formatar o sistema e quer tudo pronto em poucos minutos.

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
- ✅ Menu interativo para execução por etapas
- ✅ Verificação de pacotes já instalados para evitar duplicações

---

## 📦 Requisitos

- Ubuntu 22.04 ou superior
- Acesso root (sudo)
- Conexão com a internet

---

## 🛠️ Como usar

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/linux-posinstall.git

# Acesse a pasta
cd linux-posinstall

# Dê permissão de execução
chmod +x posinstall.sh

# Execute o script
./posinstall.sh

🧠 Observações
O DaVinci Resolve requer extração e instalação manual após o download.

Flatpaks e Snaps precisam que seus respectivos gerenciadores estejam instalados.

Caso você utilize outra versão do Ubuntu, edite as URLs e comandos conforme necessário.


🤝 Contribuições
Pull Requests e sugestões são bem-vindas! Sinta-se à vontade para abrir uma Issue com ideias, bugs ou melhorias.

📜 Licença
Este projeto está licenciado sob a MIT License.