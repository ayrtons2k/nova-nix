#REFERENCE CONFIG
{ config, pkgs, self, ... }:
{
  # In your configuration.nix

  #https://github.com/nix-community/NUR
  /*
    The Nix User Repository (NUR) is a community-driven meta repository for Nix packages. 
    It provides access to user repositories that contain package descriptions (Nix expressions) 
    and allows you to install packages by referencing them via attributes. In contrast to Nixpkgs, 
    packages are built from source and are not reviewed by any Nixpkgs member.  
  */
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
     

}
