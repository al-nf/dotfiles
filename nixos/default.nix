{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktop = import ../modules/theme.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./greeter.nix
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs (previous: {
      builder = pkgs.writeText "nvidia-builder.sh" (
        let
          originalBuilder = builtins.readFile previous.builder;
          originalCommand = "patchelf --interpreter \"$(cat $NIX_CC/nix-support/dynamic-linker)\" \\\n                    --set-rpath $out/lib:$libPath $bin/bin/$i";
        in
        if lib.hasInfix originalCommand originalBuilder then
          builtins.replaceStrings
            [ originalCommand ]
            [
              ''
                patchelf --set-rpath "$out/lib:$libPath" "$bin/bin/$i"
                                patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$bin/bin/$i"
              ''
            ]
            originalBuilder
        else
          throw "The NVIDIA patchelf workaround no longer matches the upstream builder. Check whether nixpkgs has fixed the issue before updating or removing the workaround in nixos/default.nix."
      );
    });
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;
      secureBoot.enable = true;
      biosDevice = "nodev";
      efiSupport = true;
      extraEntries = ''
        /Windows
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      maxGenerations = 5;
      style = {
        interface = {
          resolution = "1920x1080";
          branding = "Petra";
          brandingColor = "cba6f7";
          helpColor = "a6adc8";
          helpColorBright = "cba6f7";
          helpHidden = true;
        };
        graphicalTerminal = {
          font.scale = "2x2";
          palette = "45475a;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;bac2de";
          brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;a6adc8";
          foreground = "cdd6f4";
          background = "201e1e2e";
          brightForeground = "1e1e2e";
          brightBackground = "cba6f7";
          margin = 80;
          marginGradient = 8;
        };
        wallpapers = [ pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath ];
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "petra";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

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

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users = {
    afung = {
      isNormalUser = true;
      description = "Alan Fung";
      shell = pkgs.nushell;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "afung"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    home-manager
    efibootmgr
    gcc
    sbctl
  ];

  services.logind.settings.Login.IdleAction = "ignore";

  services.ratbagd.enable = true;
  services.lact.enable = true;

  services.udev.packages = [
    pkgs.openrgb
    (pkgs.writeTextFile {
      name = "petra-keyboard-udev-rules";
      destination = "/lib/udev/rules.d/70-petra-keyboard.rules";
      text = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0c45", ATTRS{idProduct}=="50e4", TAG+="uaccess"
      '';
    })
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${pkgs.coreutils}/bin/chmod a+r /sys%p/energy_uj"
    SUBSYSTEM=="usb|hidraw", ATTRS{idVendor}=="0c45", ATTRS{idProduct}=="5004", GROUP="openrgb", MODE="0660"
    SUBSYSTEM=="usb|hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c08b", GROUP="openrgb", MODE="0660"
  '';

  users.groups.openrgb = { };
  users.users.openrgb = {
    isSystemUser = true;
    group = "openrgb";
  };

  systemd.services.openrgb = {
    description = "Peripheral RGB lighting and local theme control";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-trigger.service" ];
    environment = {
      HOME = "/var/lib/openrgb";
      XDG_CONFIG_HOME = "/var/lib/openrgb/.config";
    };
    serviceConfig = {
      User = "openrgb";
      Group = "openrgb";
      StateDirectory = "openrgb";
      WorkingDirectory = "/var/lib/openrgb";
      ExecStartPre = "${pkgs.systemd}/bin/udevadm settle --timeout=10";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.openrgb)
        "--config"
        "/var/lib/openrgb"
        "--server"
        "--server-host"
        "127.0.0.1"
        "--mode"
        "Static"
        "--color"
        (lib.removePrefix "#" (builtins.head desktop.defaultTheme.colors))
      ];
      Restart = "on-failure";
      RestartSec = 2;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = "--accept-dns";
  };

  systemd.services.nvidia-gpu-init = {
    description = "Enable NVIDIA persistence mode and apply the 300 W power limit";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pm 1";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 300";
    };
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };
  system.stateVersion = "25.05";
}
