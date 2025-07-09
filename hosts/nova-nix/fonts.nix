{ config, pkgs, self, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
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
    };
  };    
}
