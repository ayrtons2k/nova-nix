#https://github.com/srid/nixos-config/tree/master/home
{
  config,
  pkgs,
  ...
}: {programs.git = {
    enable = true;
    userName = "ayrton";
    userEmail = "ayrton.mercado@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
    includes = [
        { path = "~/.gitconfig.local"; }
    ];
    };
}


 # git = {
    #   enable = true;
    #   userName = "ayrton";
    #   extraConfig = {
    #     init.defaultBranch = "main";
    #     safe.directory = "/etc/nixos";
    #   };
    # };
