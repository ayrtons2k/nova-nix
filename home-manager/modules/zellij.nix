#package definition
#https:#github.comsrid/nixos-config/tree/master/home
#
#init zoxide init nushell | save -f ~/.zoxide.nu
{ config, pkgs, ... }:
{
  programs =  {
    zellij =  {
      enable = true;
      settings =  {
          theme = "dracula";
          #theme = "cyber noid";
          default_shell = "nu";
          simplified_ui = true;
          ui = {
            pane_frames = {
              rounded_corners = true;
          };
        };         
      themes =  {
        nova-nix-latte = {
          bg= "#000000"; # Surface2
          fg= "#4c4f69"; # Text
          red= "#d20f39";
          green= "#40a02b";
          blue= "#1e66f5";
          yellow= "#55B0FA";
          magenta= "#55FAA2"; # Pink
          orange= "#F2A0FA"; # Peach
          cyan= "#04a5e5"; # Sky
          black= "#e6e9ef"; # Mantle
          white= "#4c4f69"; # Text
        };
        dracula = {
            fg ="#44475a";
            bg ="#6272a4";
            red= "#ff5555";
            green ="#bd93f9";
            yellow ="#f1fa8c";
            blue ="#8be9fd";
            magenta ="#ff79c6";
            orange ="#ffb86c";
            cyan ="#8be9fd";
            black ="#50fa7b";
            white ="#44475a";
        };

    #     nova-nix-frappe = {
    #       bg= "#626880"; # Surface2
    #       fg= "#c6d0f5"; # Text
    #       red= "#e78284";
    #       green= "#a6d189";
    #       blue= "#8caaee";
    #       yellow= "#e5c890";
    #       magenta= "#f4b8e4"; # Pink
    #       orange= "#ef9f76"; # Peach
    #       cyan= "#99d1db"; # Sky
    #       black= "#292c3c"; # Mantle
    #       white= "#c6d0f5"; # Text
    #     };

    #     nova-nix-macchiato = {
    #       bg= "#5b6078"; # Surface2
    #       fg= "#cad3f5"; # Text
    #       red= "#ed8796";
    #       green= "#a6da95";
    #       blue= "#8aadf4";
    #       yellow= "#eed49f";
    #       magenta= "#f5bde6"; # Pink
    #       orange= "#f5a97f"; # Peach
    #       cyan= "#91d7e3"; # Sky
    #       black= "#1e2030"; # Mantle
    #       white= "#cad3f5"; # Text
    #     };

    #     nova-nix-mocha = {
    #       bg= "#585b70"; # Surface2
    #       fg= "#cdd6f4"; # Text
    #       red= "#f38ba8";
    #       green= "#a6e3a1";
    #       blue= "#89b4fa";
    #       yellow= "#f9e2af";
    #       magenta= "#f5c2e7"; # Pink
    #       orange= "#fab387"; # Peach
    #       cyan= "#89dceb"; # Sky
    #       black= "#181825"; # Mantle
    #       white= "#cdd6f4"; # Text
    #     };
      };
    };
  };
};
}