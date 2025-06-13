# package definition
# https://github.comsrid/nixos-config/tree/master/home
#
{ config, pkgs, ... }:
{
  # Ensure fish is installed and its environment (XDG_DATA_DIRS) is set up
  # so Carapace can find fish completion files from other Nix packages.
  programs.fish.enable = true;

  home.packages = [
    pkgs.carapace # For Carapace completions
    # pkgs.fish is implicitly added by programs.fish.enable = true;
  ];

  programs = {
    zoxide.enableNushellIntegration = true;

    nushell = {
      enable = true;

      # Environment variables available when Nushell starts
      # Tell Carapace to bridge completions from Fish (and others if you like)
      environmentVariables = {
        CARAPACE_BRIDGES = "fish,bash,zsh"; # Add or remove bridges as needed
        NIXPKGS_ALLOW_UNFREE = "1"; # Moved from extraConfig for consistency
      };

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
        man = "navi"; # Consider if Carapace should handle navi completions or if navi has its own.
        cls = "clear";
        "core-cd" = "cd"; # Nushell's built-in cd
        cd = "z";         # zoxide for cd
        cdi = "zi";       # zoxide interactive
        ns = "nvidia-smi";
        cc = "xclip -selection clipboard";
        cv = "xclip -selection clipboard -o";
        pbcopy = "cc";
        pbpaste = "cv";
        hms = "home-manager switch --flake .#ayrton@nova-nix"; # Assuming your HM user/host
        nrs = "sudo nixos-rebuild switch --flake $HOME/nova-nix-config#nova-nix"; # Ensure flake path and host are correct
        nrsu = "sudo nixos-rebuild switch --flake $HOME/nova-nix-config#nova-nix --upgrade"; # Ensure flake path and host are correct
        nsp = "nix-shell -p ";
        nspi = "nix-shell -p inkscape";
        nspc = "nix-shell -p google-chrome";
        aliases = "scope aliases";
      };

      extraConfig = ''
        clear # Clears screen on new shell, personal preference

        # $env.NIXPKGS_ALLOW_UNFREE = 1 # Moved to environmentVariables

        # Carapace external completer setup (your existing setup, which is good)
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }

        $env.config = ($env.config | default {} | upsert completions {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
        } | upsert show_banner false) # Ensure show_banner is set correctly

        # Custom PATH modifications
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/ayrton/.apps | # Make sure this path is what you intend
          # append /usr/bin/env # This is unusual, /usr/bin should be on PATH already via NixOS
          uniq # Ensure no duplicate paths
        )

        # Example of how zoxide integration is typically handled by its Nushell support
        # The line `zoxide init nushell | save -f ~/.zoxide.nu` is not needed here
        # because `programs.zoxide.enableNushellIntegration = true;` handles it.
        # If zoxide isn't working, ensure its init script is correctly sourced by Nushell.
        # The Home Manager module should place something like:
        #   source ($env.HOME | path join ".local/share/zoxide/zoxide.nu")
        # or similar, into Nushell's startup files.

        # SSH Agent part (remains commented as per your original)
        #  ssh-add -l | find ~/.ssh/id_ed25519 | ignore
        # if $env.LAST_EXIT_CODE != 0 {
        #     # If the previous command failed (exit code != 0), the key was not found.
        #     print "Attempting to add SSH key to agent..." # Optional feedback
        #     ssh-add ~/.ssh/id_ed25519 | ignore
        # }
      '';
    };

    starship = {
      enable = true;
      settings = pkgs.lib.importTOML "./starship.toml";
      enableBashIntegration = true;
      enableFishIntegration = true; # This helps ensure fish environment is set up
      enableZshIntegration = true;
    };
  };
}
