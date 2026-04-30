{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    graphics = {
      enable = true;
      enable32Bit = true;
      #extraPackages = with pkgs; [ config.boot.kernelPackages.nvidiaPackages.stable ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    opentabletdriver.enable = true;
    xone.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "iwlwifi"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  networking = {
    hostName = "nixos-desktop";
    networkmanager.enable = true;
  };
  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  console.keyMap = "de";

  security.rtkit.enable = true;

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "memphis";
      };
    };

    desktopManager.plasma6.enable = true;

    printing.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "de";
        variant = "";
      };
      excludePackages = [
        pkgs.xterm
      ];
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  users.users.memphis = {
    isNormalUser = true;
    description = "Memphis";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs = {
    steam.enable = true;
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        myriad-dreamin.tinymist
        tomoki1207.pdf
        k--kato.intellij-idea-keybindings
        jnoortheen.nix-ide
      ];
    };
  };

  documentation.nixos.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
  };

  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/BEDE8F02DE8EB267";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=1000"
      "nofail"
      "exec"
      "umask=000"
    ];
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];
    systemPackages = with pkgs; [
      kdePackages.dolphin
      kdePackages.konsole

      vulkan-loader
      vulkan-tools

      btop
      bat
      asciiquarium
      
      thunderbird
      prismlauncher
      stremio
      vesktop
      keepassxc
      protonvpn-gui
      osu-lazer
      vlc
      
      zip
      qpwgraph

      jetbrains.idea
      jetbrains.clion

      git
      nixfmt
      docker
      typst
      gcc
      cmake
      nodejs_24
    ];
  };

  system.stateVersion = "25.11";
}
