#package definition
#https://github.comsrid/nixos-config/tree/master/home
#
#init zoxide init nushell | save -f ~/.zoxide.nu
{ config, pkgs, ... }:
{
    programs = {
        nushell = {
        enable = true;

        extraEnv = ''
            {
            show_banner: false
            }'';
        shellAliases = {
            els = "exa --color=always --icons --group";
            ell = "els -la --ignore-glob ..";
            el = "els -la --ignore-glob .?*";
            elst = "els --tree";
            elstl = "elst --long";
            elstla = "elstl --all";
            elstlale = "elstla --level";
            elstle = "elst --level";
            cat = "bat";
            "cd.." = "cd ..";
            man = "navi";
            cls="clear";
            "core-cd" = "cd";
            cd = "z";
            cdi = "zi";
            ns="nvidia-smi";
            cc="xclip -selection clipboard";
            cv="xclip -selection clipboard -o";
            pbcopy="cc";
            pbpaste="cv";
            hms="home-manager switch --flake . --impure";
            nrs="sudo nixos-rebuild switch -I nixos-config=/home/ayrton/.config/nixos/configuration.nix";
        };
        extraConfig = ''
          clear

          zoxide init nushell | save -f ~/.zoxide.nu 
     
          ssh-add ~/.ssh/id_ed25519

        
           let carapace_completer = {|spans|
           carapace $spans.0 nushell $spans | from json
           }
           $env.config = {
            show_banner: false,
            completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
                enable: true 
            # set to lower can improve completion performance at the cost of omitting some options
                max_results: 100 
                completer: $carapace_completer # check 'carapace_completer' 
              }
            }
           } 
           $env.PATH = ($env.PATH | 
           split row (char esep) |
           prepend /home/myuser/.apps |
           append /usr/bin/env
           )
         '';     
    };

    starship = {
      enable = true;
      settings = pkgs.lib.importTOML "/home/ayrton/.config/nixos/home-manager/modules/starship.toml";
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}