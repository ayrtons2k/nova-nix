# hosts/nova/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    #specific to nova-nix
    ./configuration.nix
    ./bluetooth.nix               
    ./hardware-configuration.nix
    ./graphics.nix

    #All machines
    ../../NixOS/audio.nix
    ../../NixOS/bluetooth.nix
    ../../NixOS/core.nix
    ../../NixOS/graphics.nix
    ../../NixOS/locale-NY.nix
    ../../NixOS/networking.nix
    ../../NixOS/nixpkgs-config.nix
    
    # ./services.nix
    # ./security.nix
    # ./nvidia.nix
    # ./environment.nix
    # ../../modules/nixos/core.nix
    # ../../modules/nixos/fonts.nix
    # ../../modules/nixos/users.nix
    # ../../modules/nixos/nh.nix
    # ../../modules/nixos/pipewire.nix
    # ../../modules/nixos/locale-ny.nix
    # ../../modules/nixos/pipewire.nix
    # ../../modules/nixos/bluetooth.nix
    # ../../modules/nixos/networking.nix
  ];
}