{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host wave
          Hostname login.wave.scu.edu
          User afung

      Host ecc
          Hostname linux.dc.engr.scu.edu
          User afung

      Host zeus
          Hostname zeus
          User afung

      Host braingenix
          Hostname pve.braingenix.org
          User afung
    '';
  };
}
