{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Alan Fung";
    userEmail = "alankjfung@gmail.com";
  };
}
