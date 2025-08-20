{ config, pkgs, self, ... }:
{
  services ={
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
};  };
}
