{ config, pkgs, self, ... }:
{
 nixpkgs.config = {
    allowUnfree = true;
    config = {
      allowUnfreePredicate = (_: true);
    };
  };    
}
