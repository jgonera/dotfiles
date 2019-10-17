#!/usr/bin/env bash

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

echo "Creating symlinks..."

ln -sfn "$DOTFILES_DIR/data/base16-shell" ~/.config/base16-shell
ln -sfn "$DOTFILES_DIR/data/bin" ~/bin
ln -sfn "$DOTFILES_DIR/data/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -sfn "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
ln -sfn "$DOTFILES_DIR/data/zshrc" ~/.zshrc

echo "Installing Homebrew packages..."

brew install nvim
brew install ripgrep
brew install fzf
brew install git
brew install tree

echo "Performing additional configuration..."

git config --global push.default current
git config --global rebase.autosquash true

$(brew --prefix)/opt/fzf/install

echo "Done."
