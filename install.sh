#!/bin/bash

# --- Configuration ---
# Define the root directory of your dotfiles repository
DOTFILES_DIR="$HOME/code/dotfiles"

# Define the target directory
TARGET_DIR="$HOME"

# List of files/directories to symlink.
# Paths here are relative to DOTFILES_DIR and TARGET_DIR.
# Example: ".bashrc" means "$DOTFILES_DIR/.bashrc" will be linked to "$TARGET_DIR/.bashrc"
# Example: ".config/nvim/init.lua" means "$DOTFILES_DIR/.config/nvim/init.lua" will be linked to "$TARGET_DIR/.config/nvim/init.lua"
DOTFILES=(
  ".bashrc"
  ".zshrc"
  ".tmux.conf"
  ".gitconfig"

  # Alacritty
  ".config/alacritty/alacritty.toml"
  ".config/alacritty/colors.toml"

  # Wofi configuration
  ".config/wofi/config"
  ".config/wofi/style.css"

  # wlogout
  ".config/wlogout/layout"
  ".config/wlogout/lock.png"
  ".config/wlogout/logout.png"
  ".config/wlogout/pause.png"
  ".config/wlogout/power.png"
  ".config/wlogout/restart.png"
  ".config/wlogout/sleep.png"
  ".config/wlogout/style.css"

  # Waybar
  ".config/waybar/config.jsonc"
  ".config/waybar/style.css"
  ".config/waybar/scripts/checkupdates.sh"
  ".config/waybar/scripts/colorpicker.sh"
  ".config/waybar/scripts/myUpdates.sh"

  # Hypr
  ".config/hypr/hypridle.conf"
  ".config/hypr/hyprland.conf"
  ".config/hypr/hyprlock.conf"
  ".config/hypr/hyprpaper.conf"

  ".config/hypr/hyprland/colors.conf"
  ".config/hypr/hyprland/execs.conf"
  ".config/hypr/hyprland/keybinds.conf"
  ".config/hypr/hyprland/programs.conf"
  ".config/hypr/hyprland/windows.conf"
  ".config/hypr/hyprland/workspaces.conf"

  ".config/hypr/hyprland/scripts/grimshot.sh"

  ".config/hypr/hyprlock/check-capslock.sh"
  ".config/hypr/hyprlock/status.sh"

  ".config/hypr/hyprpaper/WavesDark.jpg"
  ".config/hypr/hyprpaper/Cloudsnight.jpg"

  # Personal scripts in ~/.local/bin
  # ".local/bin/myscript.sh"
  # ".local/bin/anotherscript.py"
)

# --- Functions ---

# Function to create a symbolic link for a single file
create_file_symlink() {
  local source_path="$1" # Path relative to DOTFILES_DIR (e.g., ".config/nvim/init.lua")
  local target_path="$2" # Full path in TARGET_DIR (e.g., "/home/user/.config/nvim/init.lua")

  # Ensure the parent directory for the target symlink exists in the home directory
  # If target_path is /home/user/.config/nvim/init.lua, this creates /home/user/.config/nvim/
  mkdir -p "$(dirname "$target_path")"

  # Check if the target already exists (is a file or a symlink)
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    echo "  - $target_path already exists. Backing up to ${target_path}.bak"
    mv "$target_path" "${target_path}.bak"
  fi

  # Create the symbolic link
  echo "  - Linking $source_path to $target_path"
  ln -s "$DOTFILES_DIR/$source_path" "$target_path"
}

# --- Main Script Logic ---

echo "Starting dotfiles setup..."

# Check if the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles directory '$DOTFILES_DIR' not found."
  echo "Please clone your dotfiles repository to '$DOTFILES_DIR' first."
  exit 1
fi

# Loop through the list of dotfiles and create symlinks
for dotfile in "${DOTFILES[@]}"; do
  # Construct the full source path in the dotfiles repository
  SOURCE_FILE="$DOTFILES_DIR/$dotfile"
  # Construct the full target path in the home directory
  TARGET_FILE="$TARGET_DIR/$dotfile"

  # Check if the source file actually exists in the dotfiles repo
  if [ ! -e "$SOURCE_FILE" ]; then
    echo "Warning: Source file '$SOURCE_FILE' not found in dotfiles repository. Skipping."
    continue
  fi

  create_file_symlink "$dotfile" "$TARGET_FILE"
done

echo "Dotfiles setup complete!"
echo "Remember to source your shell configuration (e.g., 'source ~/.bashrc' or 'exec zsh') for changes to take effect."
