{ config, pkgs, ... }:

let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) {};

  customPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/5fd8536a9a5932d4ae8de52b7dc08d92041237fc.tar.gz";
    sha256 = "0hyfifrhzxsdjj80sh5fpwcgm6zq5vx6ilh0lvp2dw6fzay1vrd0";
  }) {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  cursorFlakePkg = import "~/nova-nix-config/home-manager/flakes/cursor/flake.nix";

in {

   # programs.ssh.enable = false; # Keep this commented/false if using gpg-agent for SSH

  imports = [
    #./modules/codium.nix
    ./modules/vscode.nix
    ./modules/nushell.nix
    ./modules/git.nix
    ./modules/zellij.nix
  ];

  programs.home-manager.enable = true;

  # --- Top-Level Home Block ---
  home = {
    username = "ayrton";
    homeDirectory = "/home/ayrton";
    stateVersion = "25.05"; # This version should match your NixOS version

    packages = with pkgs; [
      pkgs.gnupg # For gpg-agent
      pkgs.pinentry-tty # For gpg-agent
      alacritty            # Ensure alacritty is in packages
      bat                  # A cat clone with syntax highlighting and Git integration
      fzf                  # Command-line fuzzy finder
      ripgrep              # Line-oriented search tool
      gitAndTools.git-lfs  # Git extension for versioning large files
      gitAndTools.gh       # GitHub CLI
      htop                 # Interactive process viewer
      jq                   # Command-line JSON processor
      fd                   # Simple, fast, and user-friendly alternative to 'find'
      plasma5Packages.kdeconnect-kde       # Connect smartphones to your KDE desktop
      tmux                 # Terminal multiplexer
      lazygit              # Simple terminal UI for git commands
      lazydocker           # Simple terminal UI for docker commands
      jetbrains-mono
      ner dfonts
      #ksshaskpass          # SSH password prompt for KDE (keep if maybe used later)
      neofetch             # CLI system information tool
      fastfetch
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
      ctranslate2
      opera
      libimobiledevice
      ifuse
      vscode
      # cudatoolkit
      # customPkgs.lmstudio
    ] ++ (with unstable; [
      # Add unstable packages here
      # For example:
      # unstable.somePackage
    ]);

    # Manage Alacritty config file directly
    file.".config/alacritty/alacritty.toml" = {
      # IMPORTANT: Ensure this path is correct relative to this home.nix file.
      source = ./alacritty.toml;
    };

  }; # --- End of Top-Level Home Block ---


  # --- Top-Level Services Block ---
  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   pinentryPackage = pkgs.pinentry-tty;
  #   defaultCacheTtl = 3600; # 1 hour
  #   maxCacheTtl = 7200; # 2 hours
  #   sshKeys = [
  #     "/home/ayrton/.ssh/id_ed25519"
  #   ];
  # }; # --- End of Top-Level Services Block ---
  # --- Top-Level Programs Block ---
  programs = {

  ssh = {
      enable = true;    # This enables management of ~/.ssh/config and other client settings
      # startAgent = true; # Tells home-manager to ensure an agent is running.
                        # This might inject agent startup into shell profiles or .xsession.

      # Option A: Add standard keys automatically
      addKeysToAgent = "yes"; # Will try to add ~/.ssh/id_ed25519 etc.

      # Option B: Explicitly list identities (more control, use if Option A isn't enough or for non-standard names)
      # If you use `identities`, you might want `addKeysToAgent = "no";` or leave it unset.
      # identities = {
      #   "my-ed25519-key" = { # A descriptive name for Nix, not the filename
      #     file = "~/.ssh/id_ed25519";
      #     # You can add options here if needed, e.g.,
      #     # options = ["-t 1h"]; # Add key with a 1-hour lifetime
      #   };
      #   # Add other keys if you have them
      #   # "work-rsa-key" = { file = "~/.ssh/id_rsa_work"; };
      # };

      # Like the system config, you can set an askpass program
      # askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    };

    # Keep alacritty enabled for .desktop file etc, but NO settings block
    alacritty = {
      enable = true;
    };

    carapace = {
      enable = true;
      # carapace.enableNushellIntegration = true;     # not working
    };

    # nerd-fonts configuration would go here if using the HM module

    git = {
      enable = true;
      userName = "ayrton";
      # email = "ayrton.mercado@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true; # Assuming this works from your nushell module
    };

    # programs.zellij would go here if using the HM module, likely handled by import

    eza = {
      enable = true;
      enableNushellIntegration = true; # Assuming this works from your nushell module
    };

  }; # --- End of Top-Level Programs Block ---

}