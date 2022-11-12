sudo apt install zsh

# verificando versao
zsh --version

# setando como default. obs: precisa fazer um logout para salvar
chsh -s $(which zsh)

# pacotes necessarios
sudo apt install curl git

# instalando config
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo apt-get install dconf-cli
git clone https://github.com/dracula/gnome-terminal && cd gnome-terminal
./install.sh

#fonte
sudo apt install fonts-firacode

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

code ~/.zshrc

ZSH_THEME="spaceship"

# final do arquivo
SPACESHIP_PROMPT_ORDER=(
user          # Username section
dir           # Current directory section
host          # Hostname section
git           # Git section (git_branch + git_status)
hg            # Mercurial section (hg_branch  + hg_status)
exec_time     # Execution time
line_sep      # Line break
vi_mode       # Vi-mode indicator
jobs          # Background jobs indicator
exit_code     # Exit code section
char          # Prompt character
)
 
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_COLOR=cyan

#Plugins
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# adicione no final do .zshrc
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions