{ config, pkgs, unstable, ... }:

{
  imports = [
    ./modules/vscode.nix
    ./modules/nushell.nix
    ./modules/starship.nix
    ./modules/git.nix
    ./modules/zellij.nix
    #./modules/rust.nix
  ];

  programs.home-manager.enable = true;

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
      #(nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; }) # Optional: specify fonts
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
      slack
      nvtopPackages.full
      xclip
      ctranslate2
      #opera
      libimobiledevice
      ifuse
      vscode
    ] ++ (with unstable; [
      # Add unstable packages here, e.g., neovim
    ]);

    file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
  };

  programs = {
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    carapace = {
      enable = true;
    };

    # git = {
    #   enable = true;
    #   userName = "ayrton";
    #   extraConfig = {
    #     init.defaultBranch = "main";
    #     safe.directory = "/etc/nixos";
    #   };
    # };

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