{
  config,
  pkgs,
  inputs,
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

  programs = {
    steam.enable = true;
    thunderbird.enable = true;
    ssh.startAgent = true;
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
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
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
      "docker"
    ];
  };

  documentation.nixos.enable = false;

  nixpkgs = {
    overlays = [ inputs.nix-cachyos-kernel.overlays.default ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
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

  virtualisation.docker.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      okular
      kate
      khelpcenter
      spectacle
      ark
      elisa
      gwenview
    ];
    systemPackages = with pkgs; [
      vulkan-loader
      vulkan-tools

      btop
      bat
      zip

      fastfetch
      asciiquarium
      nyancat
      cava

      vlc
      keepassxc
      protonvpn-gui
      inputs.zen-browser.packages.${pkgs.system}.default

      vesktop
      prismlauncher
      osu-lazer
      stremio

      jetbrains.idea
      jetbrains.clion

      openconnect

      git
      nixfmt
      typst
      gcc
      cmake
      nodejs_24
    ];
  };

  system.stateVersion = "25.11";
}
