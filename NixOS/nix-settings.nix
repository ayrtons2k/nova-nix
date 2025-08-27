
{ config, pkgs, self, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  
}
