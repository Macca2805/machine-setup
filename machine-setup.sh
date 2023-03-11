# Install Homebrew
if [[ $(brew -v) ]]; then
  echo "Homebrew already installed, skipping"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update already installed packages
brew update

# 1Password
if [[ $(brew list 1password) ]]; then
  echo "1Password already installed, skipping"
else
  brew install --cask --force 1password
fi

# Hyper
if [[ $(brew list hyper) ]]; then
  echo "Hyper already installed, skipping"
else
  brew install --cask --force hyper
fi

# Visual Studio Code
if [[ $(brew list visual-studio-code) ]]; then
  echo "Visual Studio Code already installed, skipping"
else
  brew install --cask --force visual-studio-code
fi

# Gitkraken
if [[ $(brew list gitkraken) ]]; then
  echo "Gitkraken already installed, skipping"
else
  brew install --cask --force gitkraken
fi