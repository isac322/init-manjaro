#!/usr/bin/env bash

set -ex

yay -Q manjaro-zsh-config > /dev/null && yay -Rns manjaro-zsh-config --noconfirm

packages=(
  'alias-tips-git'
  'oh-my-zsh-git'
  'zsh-autosuggestions'
  'zsh-completions'
  'zsh-fast-syntax-highlighting-git'
  'zsh-history-search-multi-word-git'
  'zsh-theme-powerlevel10k'
  'chroma-bin'
  'tmux'
)
yay -S "${packages[@]}" --noconfirm --removemake --needed

cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sed -i -E 's/^export\s+ZSH=.+$/export ZSH=\/usr\/share\/oh-my-zsh/' ~/.zshrc

sed -Ei -e 's/^(ZSH_THEME=.+)$/#\1/' ~/.zshrc
perl -i -0777 -pe 's/^plugins=\([^)]*\)/plugins=(colored-man-pages colorize command-not-found extract sudo docker git pip python virtualenv archlinux systemd common-aliases docker-compose jsontools urltools dotenv aliases alias-finder history rsync tmux)/m' ~/.zshrc

tee -a ~/.zshrc > /dev/null << END

# for zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/history-search-multi-word/history-search-multi-word.plugin.zsh
source /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZSH_DOTENV_PROMPT=false
END

curl -o ~/.p10k.zsh https://gist.githubusercontent.com/isac322/641c89f4db32c3f73dc8a3eb267417f3/raw/.p10k.zsh

sudo touch /usr/share/oh-my-zsh/cache/dotenv-allowed.list /usr/share/oh-my-zsh/cache/dotenv-disallowed.list
sudo chmod 666 /usr/share/oh-my-zsh/cache/dotenv-allowed.list /usr/share/oh-my-zsh/cache/dotenv-disallowed.list
