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

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "memphis";
  services.displayManager.sddm.autoLogin.relogin = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ config.boot.kernelPackages.nvidiaPackages.stable ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opentabletdriver.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [
    "iwlwifi"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  users.users.memphis = {
    isNormalUser = true;
    description = "Memphis";
    extraGroups = [
      "networkmanager"
      "wheel"
      "fuse"
    ];
  };

  programs.steam.enable = true;

  documentation.nixos.enable = false;

  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  services.gvfs.enable = true;
  programs.gnome-disks.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware.xone.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/notifications" = {
          show-banners = false;
        };
        "org/gnome/desktop/interface" = {
          accent-color = "red";
          color-scheme = "prefer-dark";
          enable-animations = false;
          enable-hot-corners = false;
          clock-show-seconds = true;
        };
        "org/gnome/shell" = {
          favorite-apps = pkgs.lib.gvariant.mkEmptyArray pkgs.lib.gvariant.type.string;
          enabled-extensions = [
            "panel-date-format@keiii.github.com"
            "dash-to-panel@jderose9.github.com"
            "caffeine@patapon.info"
            "super-key@tommimon.github.com"
          ];
          disable-user-extensions = false;
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
        };
        "org/gnome/desktop/session" = {
          idle-delay = pkgs.lib.gvariant.mkInt32 0;
        };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
        };
        "org/gnome/shell/extensions/caffeine" = {
          show-indicator = "never";
          show-notifications = false;
          show-toggle = false;
          show-timer = false;
        };
        "org/gnome/shell/extensions/dash-to-panel" = {
          panel-sizes = builtins.toJSON {
            AOC-18DQ5HA041237 = 48;
            AOC-18DQ5HA058530 = 48;
          };
          panel-lengths = builtins.toJSON {
            AOC-18DQ5HA041237 = 100;
            AOC-18DQ5HA058530 = 100;
          };
          panel-element-positions = builtins.toJSON {
            AOC-18DQ5HA041237 = [
              {
                element = "systemMenu";
                visible = true;
                position = "stackedTL";
              }
              {
                element = "taskbar";
                visible = true;
                position = "centerMonitor";
              }
              {
                element = "dateMenu";
                visible = true;
                position = "stackedBR";
              }
              {
                element = "showAppsButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "activitiesButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "leftBox";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "centerBox";
                visible = false;
                position = "stackedBR";
              }
              {
                element = "rightBox";
                visible = false;
                position = "stackedBR";
              }
              {
                element = "desktopButton";
                visible = false;
                position = "stackedBR";
              }
            ];
            AOC-18DQ5HA058530 = [
              {
                element = "systemMenu";
                visible = true;
                position = "stackedTL";
              }
              {
                element = "taskbar";
                visible = true;
                position = "centerMonitor";
              }
              {
                element = "dateMenu";
                visible = true;
                position = "stackedBR";
              }
              {
                element = "showAppsButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "activitiesButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "leftBox";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "centerBox";
                visible = false;
                position = "stackedBR";
              }
              {
                element = "rightBox";
                visible = false;
                position = "stackedBR";
              }
              {
                element = "desktopButton";
                visible = false;
                position = "stackedBR";
              }
            ];
          };
          global-border-radius = pkgs.lib.gvariant.mkInt32 0;
          appicon-margin = pkgs.lib.gvariant.mkInt32 0;
          appicon-padding = pkgs.lib.gvariant.mkInt32 8;
          dot-style-focused = "METRO";
          dot-style-unfocused = "DASHES";
          trans-use-custom-bg = true;
          trans-use-custom-opacity = true;
          trans-bg-color = "#000000";
          trans-panel-opacity = pkgs.lib.gvariant.mkDouble 0.75;
          window-preview-padding = pkgs.lib.gvariant.mkInt32 0;
          tray-size = pkgs.lib.gvariant.mkInt32 16;
          hide-overview-on-startup = true;
        };
        "org/gnome/shell/extensions/panel-date-format" = {
          format = "%Y/%m/%d   %H:%M:%S";
        };
        "org/gnome/shell/extensions/super-key" = {
          overlay-key-action = "ulauncher-toggle";
        };
      };
    }
  ];

  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/BEDE8F02DE8EB267";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=1000"
      "nofail"
      "windows_names"
      "exec"
      "x-gvfs-show"
    ];
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      myriad-dreamin.tinymist
      tomoki1207.pdf
      k--kato.intellij-idea-keybindings
      jnoortheen.nix-ide
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
    btop
    bat
    asciiquarium
    thunderbird
    prismlauncher
    gnome-tweaks
    gnome-terminal
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-panel
    gnomeExtensions.super-key
    gnomeExtensions.panel-date-format
    gnomeExtensions.random-wallpaper
    stremio
    nautilus
    vesktop
    keepassxc
    protonvpn-gui
    ulauncher
    git
    osu-lazer
    jetbrains.idea
    jetbrains.clion
    gcc
    cmake
    zip
    vlc
    typst
    openterface-qt
    qpwgraph
    docker
    nixfmt
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  system.stateVersion = "25.11";
}
