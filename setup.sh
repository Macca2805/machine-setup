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
  running "brew $1"
  set +e
  /usr/local/bin/brew $1 >/dev/null 2>/tmp/err
  if [[ $? -ne 0 ]]; then
    failed "brew $1"
    grey "$(cat /tmp/err)"
    exit 1
  else
    completed "brew $1"
  fi
  set -e
}

function installApp {
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
  checking " - $1 (Extension)"
  if [[ $(/usr/local/bin/code --list-extensions | grep $1) ]]; then
    skipped " - $1 (Extension)"
  else
    running " - $1 (Extension)"
    set +e
    /usr/local/bin/code --force --install-extension $1 >/dev/null 2>/tmp/err
    set -e
    if [[ $? -ne 0 ]]; then
      failed " - $1 (Extension)"
      newline
      grey $(cat /tmp/err)
      exit 1
    else
      completed " - $1 (Extension)"
    fi
  fi
}

function importVisualStudioCodeSettings {
  newline
  running " - Import user settings (JSON)"
  rm -rf ~/Library/Application\ Support/Code/User/settings.json
  curl -fsSL https://raw.githubusercontent.com/Macca2805/machine-setup/main/visual-studio-code/settings.json > ~/Library/Application\ Support/Code/User/settings.json
  completed " - Import user settings (JSON)"
}

title "Machine Setup"

executeHomebrewCommand update
executeHomebrewCommand upgrade

installApp "1password"
installApp "hyper"
installApp "visual-studio-code"
installVisualStudioCodeExtension "dbaeumer.vscode-eslint"
installVisualStudioCodeExtension "yzhang.markdown-all-in-one"
installVisualStudioCodeExtension "bierner.markdown-mermaid"
installVisualStudioCodeExtension "ms-azuretools.vscode-docker"
installVisualStudioCodeExtension "github.github-vscode-theme"
importVisualStudioCodeSettings
installApp "gitkraken"
installApp "docker"

executeHomebrewCommand cleanup
newline