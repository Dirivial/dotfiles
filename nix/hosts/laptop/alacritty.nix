{ config, ... }:

{
  programs.alacritty = {
    settings = {
      window = {
        opacity = 0.95;
      };
      font = {
        size = 12.0;
      };
    };
  };
}

