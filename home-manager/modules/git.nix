#https://github.com/srid/nixos-config/tree/master/home
{
  config,
  pkgs,
  ...
}: {programs.git = {
    enable = true;
    userName = "My Name";
    userEmail = "me@example.com";
    includes = [
        { path = "~/.gitconfig.local"; }
    ];
    };
}