# dotfiles

Dotfiles I want to save for future computers or if something happens with my current one or if I decide to switch distro.

## Programs

### Install yay

```bash
sudo pacman -S --needed git base-devel && git clone <https://aur.archlinux.org/yay.git> && cd yay && makepkg -si
```

### Pacman

- alacritty
- zsh
- awww (handles wallpaper)
- gimp
- libwacom (for wacom tablet)
- wtype (emoji pasting)

### AUR

- wlogout
- chrome-bin
- visual-studio-code-bin

### Other

- [oh-my-zsh](https://ohmyz.sh/)
- tpm
- git clone <https://github.com/tmux-plugins/tpm> ~/.tmux/plugins/tpm
- tmux source ~/.tmux.conf
- (Ctrl + a) -> (Shift + i) to install plugins

## Codex Accounts

The Nix home setup installs `codex-account` and zsh helpers for switching
between Codex accounts without re-login loops.

- `codex-use personal` uses the existing `~/.codex`
- `codex-use work` uses `~/.codex-work`
- `codex-work login` logs in the work account the first time
- `codex-account list` shows which account is active

Inside the Codex microVM, `personal` stays on the mounted `~/.codex` state and
`work` lives under `~/.codex/accounts/work`, so switching accounts does not
change the VM mount source. Because the VM cannot complete the browser login
flow, its account credentials are refreshed from the host each time it starts.
Use a given account in either the host or the VM at one time, not both: refresh
tokens rotate when used.
