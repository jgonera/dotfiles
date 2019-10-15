#!/usr/bin/env bash

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

ln -sfF "$DOTFILES_DIR/data/bin" ~/bin
ln -sfF "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -sfF "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
ln -sfF "$DOTFILES_DIR/data/zshrc" ~/.zshrc

brew install nvim
brew install ripgrep
brew install fzf
brew install git
brew install tree

git config --global push.default current
git config --global rebase.autosquash true

$(brew --prefix)/opt/fzf/install
