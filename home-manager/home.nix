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
      ./modules/zellij.nix
    ];
    programs.home-manager.enable = true;

    home.username = "ayrton";
    home.homeDirectory = "/home/ayrton";
    home.stateVersion = "24.05"; # This version should match your NixOS version
    home.packages = with pkgs; [
      bat                  # A cat clone with syntax highlighting and Git integration
      fzf                  # Command-line fuzzy finder
      ripgrep              # Line-oriented search tool
      gitAndTools.git-lfs  # Git extension for versioning large files
      gitAndTools.gh       # GitHub CLI
      htop                 # Interactive process viewer
      jq                   # Command-line JSON processor
      fd                   # Simple, fast, and user-friendly alternative to 'find'
      kdeconnect           # Connect smartphones to your KDE desktop
      tmux                 # Terminal multiplexer
      lazygit              # Simple terminal UI for git commands
      lazydocker           # Simple terminal UI for docker commands
      nerdfonts            # Patched fonts with a high number of glyphs/icons
      ksshaskpass          # SSH password prompt for KDE
      neofetch             # CLI system information tool
      alacritty            # A fast, cross-platform, OpenGL terminal emulator
      navi                 # Interactive cheatsheet tool
      v4l-utils            # Video4Linux utilities
      mpv                  # Media player for testing cameras
      usbutils             # For lsusb
      guvcview             # GTK+ UVC viewer for testing webcams
      webcamoid            # Webcam management tool
      droidcam             # Use Android device as a webcam
      signal-desktop       # Private messaging app
      bash                 # GNU Bourne Again Shell
      zsh                  # Z shell
      slack                # Team communication tool
      nvtopPackages.full   # A (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
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
    #programs.zellij.enableNushellIntegration = true;

    eza = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}

