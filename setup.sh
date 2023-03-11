#!/usr/bin/env zsh
set -euo pipefail

# Update already installed packages
/usr/local/bin/brew update
/usr/local/bin/brew upgrade

# 1Password
if [[ $(/usr/local/bin/brew list 1password) ]]; then
  echo "1Password already installed, skipping"
else
  /usr/local/bin/brew install --cask --force 1password
fi

# Hyper
if [[ $(/usr/local/bin/brew list hyper) ]]; then
  echo "Hyper already installed, skipping"
else
  /usr/local/bin/brew install --cask --force hyper
fi

# Visual Studio Code
if [[ $(/usr/local/bin/brew list visual-studio-code) ]]; then
  echo "Visual Studio Code already installed, skipping"
else
  /usr/local/bin/brew install --cask --force visual-studio-code
fi

# Gitkraken
if [[ $(/usr/local/bin/brew list gitkraken) ]]; then
  echo "Gitkraken already installed, skipping"
else
  /usr/local/bin/brew install --cask --force gitkraken
fi

# Tidy up after
/usr/local/bin/brew cleanup