#https://github.com/srid/nixos-config/tree/master/home
{ config, pkgs, ... }:

let
  customPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/5fd8536a9a5932d4ae8de52b7dc08d92041237fc.tar.gz";
    sha256 = "0hyfifrhzxsdjj80sh5fpwcgm6zq5vx6ilh0lvp2dw6fzay1vrd0";
  }) {

    config = {
      allowUnfree = true;
      config = {
         allowUnfreePredicate = (_: true);
      };
    };
  };
in
  {
    imports =
    [ # Include the results of the hardware scan.
      ./modules/codium.nix
      ./modules/nushell.nix
      ./modules/git.nix
    ];
    programs.home-manager.enable = true;

    home.username = "ayrton";
    home.homeDirectory = "/home/ayrton";
    home.stateVersion = "24.05"; # This version should match your NixOS version
    home.packages = with pkgs; [
      bat                  # A cat clone with syntax highlighting and Git integration
      #eza                  # Modern replacement for ls
      fzf                  # Command-line fuzzy finder
      ripgrep              # Line-oriented search tool
      gitAndTools.git-lfs  # Git extension for versioning large files
      gitAndTools.gh       # GitHub CLI
      htop                 # Interactive process viewer
      jq                   # Command-line JSON processor
      fd                   # Simple, fast, and user-friendly alternative to 'find'
      kdeconnect           # Connect smartphones to your KDE desktop
      #zoxide               # Smarter cd command
      tmux                 # Terminal multiplexer
      lazygit              # Simple terminal UI for git commands
      lazydocker           # Simple terminal UI for docker commands
      nerdfonts            # Patched fonts with a high number of glyphs/icons
      ksshaskpass          # SSH password prompt for KDE
      #starship             # The minimal, blazing-fast, and infinitely customizable prompt for any shell
      neofetch             # CLI system information tool
      alacritty            # A fast, cross-platform, OpenGL terminal emulator
      navi                 # Interactive cheatsheet tool
      v4l-utils            # Video4Linux utilities
      mpv                  # Media player for testing cameras
      usbutils             # For lsusb
      guvcview             # GTK+ UVC viewer for testing webcams
      webcamoid            # Webcam management tool
      droidcam             # Use Android device as a webcam
      #zellij               # Terminal workspace with tabs and panes
      signal-desktop       # Private messaging app
      bash                 # GNU Bourne Again Shell
      zsh                  # Z shell
  #    nvtopPackages.full   # A (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
      xclip
  #    ollama
  #    cudatoolkit
  #    customPkgs.lmstudio
    ];

programs = {
    carapace = {
      enable = true;
      #carapace.enableNushellIntegration = true;     #not working
    };

    git = {
        enable = true; 
        userName = "ayrton";
        # email = "ayrton.mercado@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          safe.directory = "/etc/nixos";
        };
      };  

    zoxide.enable = true;
    zoxide.enableNushellIntegration = true;
    zellij.enable = true;
    #programs.zellij.enableNushellIntegration = true;

    eza = {
      enable = true;
      enableNushellIntegration = true;
    };

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
        # cd = "__zoxide_z";
        # cdi = "__zoxide_zi";
        ns="nvidia-smi";
        cc="xclip -selection clipboard";
        cv="xclip -selection clipboard -o";
        pbcopy="cc";
        pbpaste="cv";
      };
      # extraConfig = ''
      #    let carapace_completer = {|spans|
      #    carapace $spans.0 nushell $spans | from json
      #    }
      #    $env.config = {
      #     show_banner: false,
      #     completions: {
      #     case_sensitive: false # case-sensitive completions
      #     quick: true    # set to false to prevent auto-selecting completions
      #     partial: true    # set to false to prevent partial filling of the prompt
      #     algorithm: "fuzzy"    # prefix or fuzzy
      #     external: {
      #     # set to false to prevent nushell looking into $env.PATH to find more suggestions
      #         enable: true 
      #     # set to lower can improve completion performance at the cost of omitting some options
      #         max_results: 100 
      #         completer: $carapace_completer # check 'carapace_completer' 
      #       }
      #     }
      #    } 
      #    $env.PATH = ($env.PATH | 
      #    split row (char esep) |
      #    prepend /home/myuser/.apps |
      #    append /usr/bin/env
      #    )
      # '';      
  };

    # file.".config/alacritty/alacritty.yml".text = ''
    #   import:
    #     - ~/.config/alacritty/themes/themes/alacritty_0_12.yml

    #   shell:
    #     program: zellij
    # '';

    # programs.fish = {
    #   enable = true;
    #   interactiveShellInit = ''
    #     starship init fish | source

    #     alias ls='exa --color=always --icons --group';
    #     alias ll='ls -la --ignore-glob ..';
    #     alias l='ls -la --ignore-glob .?*';
    #     alias lst='ls --tree';
    #     alias lstl='lst --long';
    #     alias lstla='lstl --all';
    #     alias lstlale='lstla --level';
    #     alias lstle='lst --level';

    #     alias cls=clear;
    #     alias cat=bat;
    #     alias z=zoxide;
    #     alias "cd.."="cd ..";
    #     alias man=navi;
    #     if test -z "$SSH_AUTH_SOCK"
    #       eval (ssh-agent -c)
    #       ssh-add ~/.ssh/id_ed25519 </dev/null
    #     end
    #   '';
    # };
  };


}

