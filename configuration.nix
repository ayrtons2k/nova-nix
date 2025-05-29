{ config, pkgs, self, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.nixos.label = "tag-nova-gen-3";

  nixpkgs.config = {
    allowUnfree = true;
    config = {
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ 
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "nova-nix";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  

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

  # Enable X11 and NVIDIA
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us";
    xkb.variant = "";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;  # Use proprietary drivers
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.latest;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable KDE Plasma
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable OpenSSH
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      "D6:B9:E9:7A:65:A5" = {
        name = "MX Master 3";
        trusted = "yes";
        paired = "yes";
        auto-connect = "yes";
      };
    };
  };

  # Enable PipeWire for sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # GPU support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      linuxPackages.nvidia_x11
      libGLU
      libGL
      cudatoolkit
      gperf
    ];
  };

  #ollama
  services.ollama.enable = true;
   services.open-webui = {
     enable = true;
     environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
   };


  # User configuration
  users.users.ayrton = {
    isNormalUser = true;
    description = "ayrton";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      git
    ];
  };

  # Firefox and Git
  programs.firefox = {
  enable = true;
  package = pkgs.firefox;
  nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
};
  programs.git.config = {
    init.defaultBranch = "main";
    url."https://github.com/".insteadOf = [ "gh:" "github:" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    lnav 
  ];

  # Nix-LD for compatibility
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      fuse3
      gdk-pixbuf
      glib
      gtk3
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libglvnd
      libnotify
      #libpulseaudiofontconfig
      libunwind
      libusb1
      libuuid
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      stdenv.cc.cc
      systemd
      vulkan-loader
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      zlib
    ];
  };

  # Font configuration
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      #nerdfonts
      dejavu_fonts
      font-awesome
      liberation_ttf
      fira-code
      roboto
    ]++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";  # Options: hintnone, hintslight, hintmedium, hintfull
      };
      subpixel = {
        rgba = "rgb";  # Options: none, rgb, bgr, vrgb, vbgr
        lcdfilter = "default";  # Options: none, default, light, legacy
      };
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Fira Code" ];
      };
    };
  };

     
  system.stateVersion = "25.05";
}
