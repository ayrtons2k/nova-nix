{ config, pkgs, unstable, customPkgs, cursorFlakePkg, ... }:

{
  imports = [
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
    stateVersion = "25.05";

    packages = with pkgs; [
      gnupg
      pinentry-tty
      alacritty
      bat
      fzf
      ripgrep
      gitAndTools.git-lfs
      gitAndTools.gh
      htop
      jq
      fd
      plasma5Packages.kdeconnect-kde
      tmux
      lazygit
      lazydocker
      jetbrains-mono
      nerdfonts
      neofetch
      fastfetch
      navi
      v4l-utils
      mpv
      usbutils
      guvcview
      webcamoid
      droidcam
      signal-desktop
      bash
      zsh
      slack
      nvtopPackages.full
      xclip
      ctranslate2
      opera
      libimobiledevice
      ifuse
      vscode
      # Add cursor package if available in cursorFlakePkg
      # (cursorFlakePkg.packages.${pkgs.system}.cursor or null)
    ] ++ (with unstable; [
      # Add unstable packages here if needed
    ]);
    
    file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
  };

  # --- Top-Level Programs Block ---
  programs = {
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    alacritty = {
      enable = true;
    };

    carapace = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "ayrton";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    eza = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}