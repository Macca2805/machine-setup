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
  replace "\\r \e[36m‣\e[39m [Checking]\t$1"
}

function running {
  replace "\\r \e[36m‣\e[39m [Running]\t$1"
}

function completed {
  replace "\\r \e[32m✓\e[39m [Completed]\t$1"
}

function skipped {
  replace "\\r \e[33m-\e[39m [Skipped]\t$1"
}

function failed {
  replace "\\r \e[31m⨯\e[39m [Failed]\t$1"
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
  checking " - Install Extension $1"
  if [[ $(/usr/local/bin/code --list-extensions | grep $1) ]]; then
    skipped " - Install Extension $1"
  else
    running " - Install Extension $1"
    set +e
    /usr/local/bin/code --force --install-extension $1 >/dev/null 2>/tmp/err
    set -e
    if [[ $? -ne 0 ]]; then
      failed " - Install Extension $1"
      newline
      grey $(cat /tmp/err)
      exit 1
    else
      completed " - Install Extension $1"
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
importVisualStudioCodeSettings
installApp "gitkraken"

executeHomebrewCommand cleanup
newline