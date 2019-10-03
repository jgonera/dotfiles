#!/usr/bin/env bash

DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

brew cask install iterm2
brew install nvim
brew install ripgrep
brew install fzf
brew install git
brew install bash-completion
brew install fasd
brew install tree

git config --global push.default current
git config --global rebase.autosquash true

ln -s "$DOTFILES_DIR/data/bashrc" ~/.bashrc
ln -s "$DOTFILES_DIR/data/bashrc" ~/.bash_profile
ln -s "$DOTFILES_DIR/data/bin" ~/bin
ln -s "$DOTFILES_DIR/data/nvim" ~/.config/nvim
ln -s "$DOTFILES_DIR/data/ripgreprc" ~/.ripgreprc
