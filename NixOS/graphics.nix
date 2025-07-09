{ config, pkgs, self, ... }:
{
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      
      # settings = {
      #   Autologin = {
      #     Session = "hyprland.desktop";
      #   };
      # };
      sugarCandyNix = {
       enable = true;
        # Point this to your actual wallpaper path
        settings = {
          # Set your configuration options here.
          # Here is a simple example:
          #Background = lib.cleanSource ./background.png;
          ScreenWidth = 5120;
          ScreenHeight = 1440;
          FormPosition = "left";
          HaveFormBackground = true;
          PartialBlur = true;
        };
      };
    };
  };  
}
