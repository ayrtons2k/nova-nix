#https://github.com/srid/nixos-config/tree/master/home
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim             # open source vs code clone w/o telemetry
  ];
}

