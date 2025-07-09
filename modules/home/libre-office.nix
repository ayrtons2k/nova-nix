# modules/libreoffice.nix
{ config, pkgs, lib, ... }:

let
  # This makes it easy to reference our specific options
  cfg = config.programs.ayrton.libreoffice;
in
{
  # Define the options for our custom module
  options.programs.ayrton.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice productivity suite";

    package = lib.mkOption {
      type = lib.types.package;
      # 'fresh' has the latest features, 'still' is the long-term support version.
      default = pkgs.libreoffice-fresh;
      defaultText = "pkgs.libreoffice-fresh";
      description = "Which LibreOffice package to install.";
    };
  };

  # This part is only evaluated if you set `programs.ayrton.libreoffice.enable = true;`
  config = lib.mkIf cfg.enable {
    # Add the selected LibreOffice package to your installed packages.
    home.packages = [ cfg.package ];

    # Set environment variables for better integration.
    home.sessionVariables = {
      # This forces LibreOffice to use the GTK4 backend for native Wayland support.
      # It prevents blurry fonts and UI scaling issues on HiDPI displays in Hyprland.
      SAL_USE_VCLPLUGIN = "gtk3";
    };
  };
}