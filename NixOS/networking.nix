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

  services ={
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "9.9.9.9#dns.quad9.net" # Quad9 as a fallback
        "8.8.8.8#dns.google"   # Google as a fallback
      ];
    };    
    # Stubby DNS over TLS
      # It uses Cloudflare's DNS servers with DNSSEC validation.
      # You can customize the upstream servers and settings as needed.
      # For more information, see:  https://nixos.wiki/wiki/Encrypted_DNS
    stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [{
          address_data = "1.1.1.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        } {
          address_data = "1.0.0.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        }];
      };
    };
  };
}
