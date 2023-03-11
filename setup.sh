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

# Visual Studio Code Extensions
/usr/local/bin/code --force --install-extension dbaeumer.vscode-eslint

# Visual Studio Code User Settings (JSON)
rm -rf ~/Library/Application\ Support/Code/User/settings.json
curl -fsSL https://raw.githubusercontent.com/Macca2805/machine-setup/main/visual-studio-code/settings.json > ~/Library/Application\ Support/Code/User/settings.json

# Gitkraken
if [[ $(/usr/local/bin/brew list gitkraken) ]]; then
  echo "Gitkraken already installed, skipping"
else
  /usr/local/bin/brew install --cask --force gitkraken
fi

# Tidy up after
/usr/local/bin/brew cleanup