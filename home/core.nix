{ config, pkgs, lib, unstable, ... }:
{
  programs.home-manager.enable = true; # Technically redundant when used via NixOS module, but good practice
  services.gnome-keyring.enable = true;
  nixpkgs.config.allowUnfree = true;  
}
