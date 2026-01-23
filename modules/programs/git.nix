{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alan Fung";
        email = "alankjfung@gmail.com";
      };
    };
  };
}
