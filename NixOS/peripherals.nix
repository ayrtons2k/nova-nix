{ config, pkgs, self, ... }:
{
  hardware = {
      sane.enable = true; # enables support for SANE scanners
  };
  services ={
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };  
  };
}
