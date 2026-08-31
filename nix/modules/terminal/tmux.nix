{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    terminal = "tmux-256color";
    mouse = true;
    escapeTime = 10;
    focusEvents = true;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-save-interval '15'
          set -g @continuum-restore 'on'
        '';
      }
      minimal-tmux-status
    ];

    extraConfig = ''
      set -g default-shell "${pkgs.zsh}/bin/zsh"

      bind r source-file ~/.config/tmux/tmux.conf
      bind C-p command-prompt -I "#{session_path}" "attach-session -c '%%'"
      bind P attach-session -c "#{pane_current_path}"

      set-option -g allow-rename off

      set-option -a terminal-features 'alacritty:RGB'
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g set-titles on

      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'V' send-keys -X select-line
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
    '';
  };
}
