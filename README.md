# machine-setup

## Pre-requisites

1. Install Homebrew using the following command;

    ```zsh
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

## Configuration

Enter the following script to run the setup script

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Macca2805/machine-setup/main/setup.sh)"
```

Enter the following to configure the setup script to run at login using `launchctl`;

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Macca2805/machine-setup/main/run-at-login.sh)"
```