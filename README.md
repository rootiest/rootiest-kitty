# Rootiest Kitty Configuration

```none
 ██▀███   ▒█████   ▒█████  ▄▄▄█████▓ ██▓▓█████   ██████ ▄▄▄█████▓
▓██ ▒ ██▒▒██▒  ██▒▒██▒  ██▒▓  ██▒ ▓▒▓██▒▓█   ▀ ▒██    ▒ ▓  ██▒ ▓▒
▓██ ░▄█ ▒▒██░  ██▒▒██░  ██▒▒ ▓██░ ▒░▒██▒▒███   ░ ▓██▄   ▒ ▓██░ ▒░
▒██▀▀█▄  ▒██   ██░▒██   ██░░ ▓██▓ ░ ░██░▒▓█  ▄   ▒   ██▒░ ▓██▓ ░
░██▓ ▒██▒░ ████▓▒░░ ████▓▒░  ▒██▒ ░ ░██░░▒████▒▒██████▒▒  ▒██▒ ░
░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒░▒░▒░   ▒ ░░   ░▓  ░░ ▒░ ░▒ ▒▓▒ ▒ ░  ▒ ░░
  ░▒ ░ ▒░  ░ ▒ ▒░   ░ ▒ ▒░     ░     ▒ ░ ░ ░  ░░ ░▒  ░ ░    ░
  ░░   ░ ░ ░ ░ ▒  ░ ░ ░ ▒    ░       ▒ ░   ░   ░  ░  ░    ░
   ░         ░ ░      ░ ░            ░     ░  ░      ░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░
░▒▓███████▓▒░░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░    ░▒▓██████▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░

        ▄████▄   ▒█████   ███▄    █   █████▒
        ▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █ ▓██   ▒
        ▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒▒████ ░
        ▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒░▓█▒  ░
        ▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░░▒█░
        ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒ ░
        ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░ ░
        ░        ░ ░ ░ ▒     ░   ░ ░  ░ ░
        ░ ░          ░ ░           ░
        ░

            _..---...,""-._     ,/}/)
         .''        ,      ``..'(/-<
        /   _      {      )         \
       ;   _ `.     `.   <         a(
     ,'   ( \  )      `.  \ __.._ .: y
    (  <\_-) )'-.____...\  `._   //-'
     `. `-' /-._)))      `-._)))
       `...'
```

The rootiest kitty configuration you will ever see!

## Installation

1. Install [kitty](https://sw.kovidgoyal.net/kitty/)

2. Install pre-requisites

   - Required
     - [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/) -
       Nerd Fonts glyphs are required.
   - Optional
     - [fish](https://fishshell.com/)
     - [neovim](https://neovim.io/)

3. Backup your current kitty configuration (if you have one)

   ```bash
   mv ~/.config/kitty ~/.config/kitty.bak
   ```

4. Clone the repository

   ```bash
   git clone --recurse-submodules https://github.com/rootiest/rootiest-kitty.git ~/.config/kitty
   ```

   If you already cloned without `--recurse-submodules`, initialize submodules manually:

   ```bash
   git submodule update --init
   ```

5. **Enjoy!** 🎉

## Features

- Smart key bindings
- Integration with NeoVim
- Integration with fish shell
- Catppuccin theme by default
- Integrates cleanly with other Rootiest projects
- Single clean session with splits layout

## Companion Tools

[Rootiest Fish](https://github.com/rootiest/rootiest-fish) -
Fish shell configuration that pairs well with this kitty configuration
and the NeoVim configuration.

[Rootiest Tmux](https://github.com/rootiest/rootiest-tmux) -
A tmux configuration that is designed to work with this kitty config.

[Rootiest Neovim](https://github.com/rootiest/rootiest-nvim) -
A NeoVim config built to work alongside this and the fish config.

[Rootiest Iosevka Font](https://github.com/rootiest/rootiest-iosevka) -
A custom Iosevka font that is designed by developers, for developers.

[Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/) -
A collection of fonts that include many icons and glyphs that are used in this configuration.

## Dotfiles

[Rootiest Dotfiles](https://github.com/rootiest/dotfiles)

## Credits

- [kitty](https://sw.kovidgoyal.net/kitty/)
- [kitty-scrollback](https://github.com/mikesmithgh/kitty-scrollback.nvim)
- [kitty-search](https://github.com/trygveaa/kitty-kitten-search)
- [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator)
