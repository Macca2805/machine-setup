#!/usr/bin/env zsh
set -euo pipefail

function newline {
  echo -e ""
}

function title {
  newline
  echo -e "\e[4m$1\e[0m"
  newline
}

function replace {
  tput cuu1
  tput el
  echo -e $1
}

function checking {
  replace "\\r \e[36m‣\e[39m [Checking]\t\e[37m$1\e[39m"
}

function running {
  replace "\\r \e[36m‣\e[39m [Running]\t\e[37m$1\e[39m"
}

function completed {
  replace "\\r \e[32m✓\e[39m [Completed]\t\e[37m$1\e[39m"
}

function skipped {
  replace "\\r \e[33m-\e[39m [Skipped]\t\e[37m$1\e[39m"
}

function failed {
  replace "\\r \e[31m⨯\e[39m [Failed]\t\e[37m$1\e[39m"
}

function grey {
  replace "\\r\e[2m$1\e[22m\n"
}

function executeHomebrewCommand {
  newline
  running "brew $*"
  set +e
  /usr/local/bin/brew $* >/dev/null 2>/tmp/err
  if [[ $? -ne 0 ]]; then
    failed "brew $*"
    grey "$(cat /tmp/err)"
    exit 1
  else
    completed "brew $*"
  fi
  set -e
}

function install {
  newline
  checking "brew install $1"
  if [[ $(/usr/local/bin/brew list | grep $1) ]]; then
    skipped "brew install $1"
  else
    running "brew install $1"
    set +e
    /usr/local/bin/brew install --cask --force $1 >/dev/null 2>/tmp/err
    set -e
    if [[ $? -ne 0 ]]; then
      failed "brew install $1"
      newline
      grey $(cat /tmp/err)
      exit 1
    else
      completed "brew install $1"
    fi
  fi
}

function installVisualStudioCodeExtension {
  newline
  checking " - Extension: $1"
  if [[ $(/usr/local/bin/code --list-extensions | grep $1) ]]; then
    skipped " - Extension: $1"
  else
    running " - Extension: $1"
    set +e
    /usr/local/bin/code --force --install-extension $1 >/dev/null 2>/tmp/err
    set -e
    if [[ $? -ne 0 ]]; then
      failed " - Extension: $1"
      newline
      grey $(cat /tmp/err)
      exit 1
    el
      completed " - Extension: $1"
    fi
  fi
}

function importVisualStudioCodeSettings {
  newline
  running " - Import settings file"
  rm -rf ~/Library/Application\ Support/Code/User/settings.json
  curl -fsSL https://raw.githubusercontent.com/Macca2805/machine-setup/main/visual-studio-code/settings.json > ~/Library/Application\ Support/Code/User/settings.json
  completed " - Import settings file"
}

title "Machine Setup"

executeHomebrewCommand update
executeHomebrewCommand upgrade
executeHomebrewCommand tap homebrew/cask-fonts

install "font-jetbrains-mono"
install "warp"
install "terraform"
install "visual-studio-code"
installVisualStudioCodeExtension "dbaeumer.vscode-eslint"
installVisualStudioCodeExtension "yzhang.markdown-all-in-one"
installVisualStudioCodeExtension "bierner.markdown-mermaid"
installVisualStudioCodeExtension "ms-azuretools.vscode-docker"
installVisualStudioCodeExtension "GitHub.github-vscode-theme"
installVisualStudioCodeExtension "hashicorp.terraform"
importVisualStudioCodeSettings
install "raycast"
install "gitkraken"
install "docker"
install "slack"
install "1password"
install "notion"

executeHomebrewCommand cleanup
newline