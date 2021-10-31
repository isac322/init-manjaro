#!/usr/bin/env bash

set -ex

yay -Q manjaro-zsh-config > /dev/null && yay -Rns manjaro-zsh-config --noconfirm

packages=(
  'alias-tips-git'
  'oh-my-zsh-git'
  'zsh-autosuggestions'
  'zsh-completions'
  'zsh-syntax-highlighting-git'
#  'zsh-history-search-multi-word-git'
  'zsh-theme-powerlevel10k'
  'chroma-bin'
)
yay -S "${packages[@]}" --noconfirm --removemake --needed

cp /usr/share/oh-my-zsh/zshrc ~/.zshrc

sed -i '1i# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.\n# Initialization code that may require console input (password prompts, [y/n]\n# confirmations, etc.) must go above this block; everything else may go below.\nif [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then\n  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"\nfi\n\n' ~/.zshrc
sed -Ei -e 's/^(ZSH_THEME=.+)$/#\1/' ~/.zshrc
perl -i -0777 -pe 's/^plugins=\([^)]*\)/plugins=(colored-man-pages colorize command-not-found extract sudo docker git pip python virtualenv archlinux systemd cargo common-aliases docker-compose jsontools rust urltools dotenv aliases alias-finder aws golang helm history kubectl rsync tmux)/m' ~/.zshrc

tee -a ~/.zshrc > /dev/null << END

# for zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZSH_DOTENV_PROMPT=false
END

curl -o ~/.p10k.zsh https://gist.githubusercontent.com/isac322/641c89f4db32c3f73dc8a3eb267417f3/raw/.p10k.zsh

chsh -s "$(which zsh)"
