{ config, pkgs, lib, ... }:

{
  # Enable WSL
  wsl.enable = true;
  wsl.defaultUser = "afung";
  
  # Set hostname
  networking.hostName = "pharos";

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define user account
  users.users.afung = {
    isNormalUser = true;
    description = "Alan Fung";
    shell = pkgs.nushell;
    extraGroups = [ "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    home-manager
    gcc
    nushell
    wslu
  ];

  # Enable Docker (optional, but useful in WSL)
  virtualisation.docker.enable = true;

  # Enable SSH daemon (optional)
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05";
}
