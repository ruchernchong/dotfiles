# Ru Chern's Dotfiles

This repository contains dotfiles and scripts that I used to customise my macOS/Linux and development workflow I use on a day-to-day basis. You are free to use this as a reference for your own setup.

![Terminal](terminal.png)

## Features

- Installs Oh-My-Zsh by default
- Common git aliases that is being used on a day-to-day basis
- Customised oh-my-zsh settings
- [Setup script](setup.sh)

## Installation

**Warning:** Do not blindly use my settings as it may override or modify some of your own configuration. You can use this as a reference. It is highly recommended to clone/fork this repository to another folder. Use at your own risk!

### OTA installation

```zsh
curl -L https://raw.githubusercontent.com/ruchernchong/dotfiles/master/install.sh | bash
```

### Cloning the repository

```zsh
git clone https://github.com/ruchernchong/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod a+x setup.sh
source setup.sh
```

## Feedback

I welcome any feedbacks or suggestions by creating an [issue](https://github.com/ruchernchong/dotfiles/issues) or a [pull request](https://github.com/ruchernchong/dotfiles/pulls).

## License

This code is available under the [MIT License](LICENSE)
