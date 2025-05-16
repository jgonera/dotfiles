#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

echo "Creating symlinks..."

mkdir ~/.config || true
mkdir ~/.config/bat || true

ln -sfn "$DOTFILES_DIR/data/alacritty" ~/.config/alacritty
ln -sfn "$DOTFILES_DIR/data/bat.conf" ~/.config/bat/config
ln -sfn "$DOTFILES_DIR/data/bin" ~/bin
ln -sfn "$DOTFILES_DIR/data/git" ~/.config/git
ln -sfn "$DOTFILES_DIR/data/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -sfn "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
ln -sfn "$DOTFILES_DIR/data/wezterm.lua" ~/.wezterm.lua
ln -sfn "$DOTFILES_DIR/data/zprofile" ~/.zprofile
ln -sfn "$DOTFILES_DIR/data/zshrc" ~/.zshrc

echo "Installing Homebrew..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing Homebrew packages..."

brew install --cask alacritty
brew install --cask font-hack
brew install --cask karabiner-elements
brew install --cask keepassxc
brew install --cask wezterm
brew install bat
brew install eza
brew install fd
brew install fzf
brew install git
brew install git-delta
brew install nvim
brew install ripgrep
brew install syncthing

echo "Performing additional configuration..."

$(brew --prefix)/opt/fzf/install

# https://github.com/zsh-users/zsh-completions/issues/433
# sudo chown -R "$USER" /usr/local/share/zsh
# sudo chmod -R 755 /usr/local/share/zsh

# https://github.com/alacritty/alacritty/issues/4616#issuecomment-1236413444
# defaults write -g AppleFontSmoothing -int 0

echo "Done."
