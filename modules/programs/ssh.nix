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
    '';
  };
}
