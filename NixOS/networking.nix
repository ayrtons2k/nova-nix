{ config, pkgs, self, ... }:
let
  # Fetch the Steven Black hosts file.
  stevenBlackHosts = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    sha256 = "sha256:0mlx9l8k3mmx41hrlmqk6bibz8fvg6xzzpazkfizkc8ivw2nrgb7";
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
