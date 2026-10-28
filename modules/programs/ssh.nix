{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      wave = {
        HostName = "login.wave.scu.edu";
        User = config.home.username;
      };
      ecc = {
        HostName = "linux.dc.engr.scu.edu";
        User = config.home.username;
      };
      zeus = {
        HostName = "zeus";
        User = config.home.username;
      };
      braingenix = {
        HostName = "pve.braingenix.org";
        User = config.home.username;
      };
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
