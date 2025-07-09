{ config, pkgs, self, ... }:
{
environment = {
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
}
