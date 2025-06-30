#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

echo "Creating symlinks..."

mkdir ~/.config || true
mkdir ~/.config/bat || true
mkdir ~/.config/darktable || true
mkdir -p ~/Library/Preferences/org.videolan.vlc || true

ln -sfn "$DOTFILES_DIR/data/aider.conf.yml" ~/.aider.conf.yml
ln -sfn "$DOTFILES_DIR/data/alacritty" ~/.config/alacritty
ln -sfn "$DOTFILES_DIR/data/amethyst.yml" ~/.amethyst.yml
ln -sfn "$DOTFILES_DIR/data/bat.conf" ~/.config/bat/config
ln -sfn "$DOTFILES_DIR/data/bin" ~/bin
ln -sfn "$DOTFILES_DIR/data/darktable/darktablerc" ~/.config/darktable/darktablerc
ln -sfn "$DOTFILES_DIR/data/git" ~/.config/git
ln -sfn "$DOTFILES_DIR/data/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES_DIR/data/mise" ~/.config/mise
ln -sfn "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -sfn "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
ln -sfn "$DOTFILES_DIR/data/vlcrc" ~/Library/Preferences/org.videolan.vlc/vlcrc
ln -sfn "$DOTFILES_DIR/data/wezterm.lua" ~/.wezterm.lua
ln -sfn "$DOTFILES_DIR/data/zprofile" ~/.zprofile
ln -sfn "$DOTFILES_DIR/data/zshrc" ~/.zshrc

echo "Installing Rosetta..."

softwareupdate --install-rosetta

echo "Installing Homebrew..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing Homebrew packages..."

brew install --cask alacritty
brew install --cask amethyst
brew install --cask android-studio
brew install --cask darktable
brew install --cask firefox
brew install --cask font-hack
brew install --cask google-chrome
brew install --cask google-cloud-sdk
brew install --cask karabiner-elements
brew install --cask keepassxc
brew install --cask maccy
brew install --cask microsoft-teams
brew install --cask nordvpn
brew install --cask obsidian
brew install --cask spotify
brew install --cask syncthing
brew install --cask vlc
brew install --cask wezterm
brew install --cask whatsapp
brew install actionlint
brew install aria2
brew install bat
brew install cocoapods
brew install eza
brew install fd
brew install fzf
brew install git
brew install git-delta
brew install mise
brew install nvim
brew install opentofu
brew install ripgrep
brew install selene
brew install stylua
brew install uv
brew install vips

echo "Installing additional dev tools..."

mise install

# Language servers
mise exec node -- npm install --global @astrojs/language-server vscode-langservers-extracted

# Workaround for XCode not seeing mise-installed tools
sudo mkdir -p /usr/local/bin
sudo ln -sf ~/.local/share/mise/shims/node /usr/local/bin/node
sudo ln -sf ~/.local/share/mise/shims/npm /usr/local/bin/npm

echo "Performing additional configuration..."

$(brew --prefix)/opt/fzf/install

# https://github.com/zsh-users/zsh-completions/issues/433
# sudo chown -R "$USER" /usr/local/share/zsh
# sudo chmod -R 755 /usr/local/share/zsh

# https://github.com/alacritty/alacritty/issues/4616#issuecomment-1236413444
# defaults write -g AppleFontSmoothing -int 0

echo "Done."
