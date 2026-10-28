{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim";
      user = {
        name = "Alan Fung";
        email = "alankjfung@gmail.com";
      };
      credential = {
        helper = "!gh auth git-credential";
        "https://huggingface.co".helper = "store";
      };
    };
  };
}
