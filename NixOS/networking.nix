{ config, pkgs, self, ... }:
let
  # Fetch the Steven Black hosts file.
  stevenBlackHosts = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    sha256 = "sha256:1yrwn94qyhjifvs8jfv5r00fwkr7l5xqxgwa3n40sq52va8c2vcx";
  };
in 
{
  networking = {
    extraHosts = builtins.readFile stevenBlackHosts;  
    hostName = "nova-nix";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  };

    
}
