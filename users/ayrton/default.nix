{ config, pkgs, self, ... }:
{
  users.users.ayrton = {
    isNormalUser = true;
    description  = "ayrton";
    extraGroups  = [ "networkmanager" "wheel" ];
    packages     = with pkgs; [
      kdePackages.kate
      git
    ];
  };  
}
