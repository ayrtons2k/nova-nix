{ config, pkgs, self, ... }:
{
  hardware = {
    bluetooth = {
      settings = {
        "D6:B9:E9:7A:65:A5" = {
          name = "MX Master 3";
          trusted = "yes";
          paired = "yes";
          auto-connect = "yes";
        };
      };
    };
  };

    
}
