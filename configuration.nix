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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs; };

    users.memphis = {
      imports = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];

      programs = {
        plasma = {
          enable = true;

          workspace = {
            clickItemTo = "select";
            lookAndFeel = "org.kde.breezedark.desktop";
            wallpaper = "/etc/nixos/assets/wallpaper.jpeg";
          };

          panels = [
            {
              location = "bottom";
              screen = "all";
              alignment = "center";
              widgets = [
                "org.kde.plasma.kickoff"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.icontasks"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.digitalclock"
              ];
            }
          ];
        };
      };

      home.stateVersion = "25.11";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [
      pkgs.linux-firmware
      pkgs.sof-firmware
    ];
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
    xone.enable = true;
    printers = {
      ensurePrinters = [
        {
          name = "canon_mg7750_series";
          description = "Canon MG7750 Series";
          location = "Server";
          deviceUri = "ipp://192.168.178.42/ipp/print";
          model = "everywhere";
        }
      ];
      ensureDefaultPrinter = "canon_mg7750_series";
    };
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
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall.checkReversePath = false;
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

  fileSystems = {
    "/home" = {
      device = "/dev/disk/by-uuid/fd9390a5-93d5-4c43-beac-90dcf1de0a59";
      fsType = "ext4";
      options = [
        "rw"
        "nofail"
      ];
    };
  };

  systemd.services.fix-mnt-permissions = {
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/chown -R memphis:users /mnt";
    };
  };

  virtualisation.docker.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      okular
      kate
      khelpcenter
      ark
      elisa
      gwenview
    ];
    systemPackages = with pkgs; [
      # Graphics Dependencies
      vulkan-loader
      vulkan-tools

      # Linux Tools
      btop
      bat
      zip
      unzip
      tree
      rclone

      # Nerdy linux shit
      fastfetch
      asciiquarium
      nyancat
      cava

      # Tools
      vlc
      keepassxc
      protonvpn-gui
      libreoffice
      wireshark
      inputs.zen-browser.packages.${pkgs.system}.default

      vesktop
      stremio

      # Games
      olympus
      osu-lazer
      prismlauncher

      # Codingers
      jetbrains.idea
      jetbrains.clion
      jetbrains.pycharm
      unityhub

      # More Codingers
      git
      nixfmt
      typst
      gcc
      cmake
      gnumake
      nodejs_24
      python3

      # Testing
      wireguard-tools
      linuxHeaders
    ];
  };

  system.stateVersion = "25.11";
}
