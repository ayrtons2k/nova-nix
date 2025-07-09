{ config, pkgs, self, ... }:
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    };    
  };
}
