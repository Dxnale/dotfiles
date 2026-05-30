# Dotfiles

> Configuration of software I personally use for everyday work and fun.

**WARNING:** it's for me and myself only,
I don't recommend to run it on your own machines.

If you're not me (lol), just clone this repository and
poke into configuration files (it's in `config` directory!).

## How it works?

This repository contains:

- `config` -- a bunch of configuration files and templates. Main directory here

It mean to be used as a source for symlinks in the home directory. For example, `config/.zshrc` is a source for `~/.zshrc` file.

## Tools needed

- `lnko` -- a tool to manage symlinks. You can install it with your package manager, for example:

```bash
# Install
curl -fsSL https://raw.githubusercontent.com/luanvil/lnko/main/install.sh | bash

# Usage
cd config

lnko link -b apps cosmic fastfetch fonts git scripts wallpapers zsh
```
