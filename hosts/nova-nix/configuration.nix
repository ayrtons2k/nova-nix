#REFERENCE CONFIG
{ config, pkgs, self, ... }:
{
  # In your configuration.nix
  services = {
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
  };
 
  # This enables the daemon that talks to the YubiKey hardware
  #services.pcscd.enable = true;
  security = {
    rtkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
    pam.services.swaylock = {
      text = "auth include login";
    };  

    pam = {
      u2f = {
        enable = true;
        control = "sufficient"; # This means the key is SUFFICIENT for auth.
        settings = {
          cue = true;             # Prints "Please touch the device."
          authFile = "/home/ayrton/.config/Yubico/u2f_keys"; # Path to your Yubikey key file};
          origin = "pam://ayrton-local-nix-auth";     
        };
      };
      services =  {
    # This enables U2F/Passkey authentication for the 'sudo' service
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        u2f.enable = true;
      };       
    };
  }; 

  services.udev.packages = [ pkgs.libu2f-host ];
  environment = {
    #Variables used by Hyprland
    
    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NIXOS_OZONE_WL = "1"; # Hint for Electron apps to use Wayland
      WLR_NO_HARDWARE_CURSORS = "1";
      HYPRCURSOR_THEME = "Future-Cyan";
      HYPRCURSOR_SIZE = "24";
   };    
    systemPackages = with pkgs; [
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
      hyprpaper # Wallpaper daemon for Hyprland
      hyprlock # The native screen locker
      kdePackages.qtsvg
      kdePackages.dolphin
      pam_u2f
      peazip
      nix-output-monitor
      nvd
    ];
  };

   programs.thunar = {
    enable = true;
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
        style = "none";  # Options: "none", "slight", "medium", "full"'. 
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
  #https://github.com/nix-community/NUR
  /*
    The Nix User Repository (NUR) is a community-driven meta repository for Nix packages. 
    It provides access to user repositories that contain package descriptions (Nix expressions) 
    and allows you to install packages by referencing them via attributes. In contrast to Nixpkgs, 
    packages are built from source and are not reviewed by any Nixpkgs member.  
  */
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
     
  system.stateVersion = "25.05";
}
