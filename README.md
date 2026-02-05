# dotfiles

My very boring dotfiles

## My Setup
- Nvim as the editor
- Hyprland for my Linux window manager
- Ghostty as my terminal of choice
- Zsh for my shell with oh-my-zsh for theming/plugins

## Installation

There is an included bootstrap.sh script to install all dependencies, backup existing dotfiles if needed, and symlink everything from here.

```bash
./bootstrap.sh
```

## Local Overrides
- `~/.gitconfig.local` - machine-specific git settings
- `~/.zshrc-local` - machine-specific shell configuration

## Credits
Setup based on [this great article](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html)
