#https://github.com/srid/nixos-config/tree/master/home
#https://nixos.wiki/wiki/Node.js
{
  config,
  pkgs,
  ...
}: 

{programs.nodejs = {
    enable = true;
   
    };
}