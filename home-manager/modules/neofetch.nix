#package definition
#https://github.comsrid/nixos-config/tree/master/home
#
#init zoxide init nushell | save -f ~/.zoxide.nu
{ config, pkgs, ... }:
{
    programs = {
        neofetch = {
            enable = true;
        };
    };

}



