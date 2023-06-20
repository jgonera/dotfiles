#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

echo "Creating symlinks..."

mkdir ~/.config || true
mkdir ~/.config/bat || true

ln -sfn "$DOTFILES_DIR/data/bat.conf" ~/.config/bat/config
ln -sfn "$DOTFILES_DIR/data/bin" ~/bin
ln -sfn "$DOTFILES_DIR/data/gitconfig" ~/.gitconfig
ln -sfn "$DOTFILES_DIR/data/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -sfn "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
ln -sfn "$DOTFILES_DIR/data/wezterm.lua" ~/.wezterm.lua
ln -sfn "$DOTFILES_DIR/data/zshrc" ~/.zshrc

echo "Installing Homebrew packages..."

brew install --cask wezterm
brew install bat
brew install exa
brew install fd
brew install fzf
brew install git
brew install git-delta
brew install nvim
brew install ripgrep

echo "Performing additional configuration..."

$(brew --prefix)/opt/fzf/install

# https://github.com/zsh-users/zsh-completions/issues/433
sudo chown -R "$USER" /usr/local/share/zsh
sudo chmod -R 755 /usr/local/share/zsh

echo "Done."
