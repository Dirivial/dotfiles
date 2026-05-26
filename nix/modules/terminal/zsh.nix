{ config, lib, ... }:

{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "crunch";
      plugins = [
        "git"
        "tmux"
      ];
      extraConfig = ''
        ZSH_TMUX_AUTOSTART=true
      '';
    };

    sessionVariables = {
      MANPAGER = "nvim +Man!";
      PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    };

    initContent = lib.mkAfter ''
      if [[ -n "$SSH_CONNECTION" ]]; then
        export EDITOR="vim"
      else
        export EDITOR="nvim"
      fi

      path+=("$PNPM_HOME" "$HOME/go/bin")

      if [[ -f "$HOME/.local/bin/env" ]]; then
        . "$HOME/.local/bin/env"
      fi
    '';
  };
}
