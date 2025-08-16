{ config, pkgs, ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 120;
        autosens = 1;
      };
      input = {
        method = "pipewire";
        source = "auto";
      };
      output = {
        channels = "mono";
      };
    };
  };
}
