# Ru Chern's Dotfiles

[![Build Status](https://travis-ci.org/ruchern/dotfiles.svg?branch=master)](https://travis-ci.org/ruchern/dotfiles)

This repository contains dotfiles and scripts that I used to customise my macOS/Linux and development workflow I use on a day-to-day basis. You are free to use this as a reference for your own setup.

![Terminal](terminal.png)

## Features

- Installs Oh-My-Zsh by default
- Common git aliases that is being used on a day-to-day basis
- Customised oh-my-zsh settings
- [Setup script](setup.sh)
- Cron job(s) to clean cache on a weekly basis

## Installation

**Warning:** Do not blindly use my settings as it may override or modify some of your own configuration. You can use this as a reference. It is highly recommended to clone/fork this repository to another folder. Use at your own risk!

```bash
git clone https://github.com/ruchern/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod a+x setup.sh
source setup.sh
```

## License

This code is available under the [MIT License](LICENSE)
