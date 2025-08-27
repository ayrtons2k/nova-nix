# hosts/nova/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    #specific to nova-nix
    ./bluetooth.nix               
    ./environment.nix
    ./fonts.nix
    ./graphics.nix
    ./hardware-configuration.nix
    #./nur.nix
    ./security.nix

    #All machines
    ../../NixOS/audio.nix
    ../../NixOS/printers.nix
    ../../NixOS/bluetooth.nix
    ../../NixOS/core.nix
    ../../NixOS/fonts.nix
    ../../NixOS/graphics.nix
    ../../NixOS/locale-NY.nix
    ../../NixOS/networking.nix
    ../../NixOS/nixpkgs-config.nix
    ../../NixOS/nix-settings.nix

    #user definitions
    ../../users/ayrton/default.nix
   
  ];
}