# hosts/nova/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../NixOS/core.nix
    ../../NixOS/networking.nix
    ../../home/core.nix
    
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