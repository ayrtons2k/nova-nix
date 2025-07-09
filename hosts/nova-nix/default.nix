# hosts/nova/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    #specific to nova-nix
    ./configuration.nix
    ./bluetooth.nix               
    ./hardware-configuration.nix
    ./graphics.nix
    ./security.nix
    ./environment.nix
    ./fonts.nix

    #All machines
    ../../NixOS/audio.nix
    ../../NixOS/bluetooth.nix
    ../../NixOS/core.nix
    ../../NixOS/fonts.nix
    ../../NixOS/graphics.nix
    ../../NixOS/locale-NY.nix
    ../../NixOS/networking.nix
    ../../NixOS/nixpkgs-config.nix

    #user definitions
    ../../users/ayrton/default.nix
    
  ];
}