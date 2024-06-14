#https://github.com/srid/nixos-config/tree/master/home
{
  config,
  pkgs,
  ...
}: {programs.git = {
    enable = true;
    userName = "ayrton";
    userEmail = "ayrton.mercado@gmail.com";
    includes = [
        { path = "~/.gitconfig.local"; }
    ];
    };
}