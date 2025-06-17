{ config, pkgs, self, ... }:
let
  # Fetch the Steven Black hosts file.
  # This makes your configuration self-contained and reproducible.
  stevenBlackHosts = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    # The sha256 hash ensures the file we download is the one we expect.
    # See below for how to get/update this hash.
    sha256 = "0sj4lbw2sgk29n2x7ba7kvycz2114q32rhivjxkwikr5cmdj2djk";
  };

in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.nixos.label = "flake-gen-2-impure";

  nixpkgs.config = {
    allowUnfree = true;
    config = {
      allowUnfreePredicate = (_: true);
    };
  };
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "9.9.9.9#dns.quad9.net" # Quad9 as a fallback
      "8.8.8.8#dns.google"   # Google as a fallback
    ];
  };
  # Stubby DNS over TLS
  # This is an example configuration for Stubby, a DNS over TLS client.
  # It uses Cloudflare's DNS servers with DNSSEC validation.
  # You can customize the upstream servers and settings as needed.
  # For more information, see:  https://nixos.wiki/wiki/Encrypted_DNS
  services.stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [{
          address_data = "1.1.1.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        } {
          address_data = "1.0.0.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        }];
      };
    };



  imports = [ 
    ./hardware-configuration.nix
  ];

  # networking.extraHosts takes a string and appends it to /etc/hosts.
  # We read the file we just fetched and use its content.
  networking.extraHosts = builtins.readFile stevenBlackHosts;  



  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
 boot.kernelParams = [ "nvidia_drm.modeset=1" ];  

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

  # Enable Wayland and the Sway compositor
  programs.sway.enable = true;

  # # Enable XWayland to run X11 applications on Wayland
  # services.xserver.xwayland.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;  # Use proprietary drivers
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.latest;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = config.boot.kernelPackages.nvidiaPackages.production;
  };

 
  services.displayManager.sddm = {
    enable = true;
     settings = {
      Autologin = {
        Session = "sway.desktop";
      };
    };
  };

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
    # rofi  
    wofi # Wayland-native replacement for Rofi
    mako # Wayland-native notification daemon
    swaybg # Sway's own background/wallpaper tool
    wdisplays # Wayland-native display configuration tool
    grim # Wayland screenshot tool
    slurp # Wayland region selection tool (used with grim)
    pavucontrol
    nwg-look # GTK theme configuration for Wayland
    networkmanagerapplet
    blueman
    wl-clipboard # Provides wl-copy/wl-paste for the command line
    swaylock # The Wayland-native screen locker for Sway
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
      microsoft-edge
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
