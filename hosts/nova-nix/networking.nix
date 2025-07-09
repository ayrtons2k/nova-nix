{ config, pkgs, self, ... }:
{
  networking = {
    hostName = "nova-nix";
    networkmanager = {
      enable = true
    };        
  };
}
