{ config, pkgs, unstable, ... }:

{
  imports = [
    ./modules/hyprland.nix
    ./modules/vscode.nix
    ./modules/nushell.nix
    ./modules/starship.nix
    ./modules/git.nix
    ./modules/zellij.nix
    #./modules/rust.nix
  ];
  xsession = {
    enable = true;
    # windowManager = {
    #   i3 = {
    #     enable = true;
    #     package = pkgs.i3-gaps;        
    #     extraConfig = ''
    #       # Set the default terminal emulator
    #       exec_always --no-startup-id alacritty
    #     '';
    #   };
    # };


  };  

  programs.home-manager.enable = true;
 services.gnome-keyring.enable = true;

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
      eza
      zoxide
      ripgrep
      gitAndTools.git-lfs
      gitAndTools.gh
      htop
      jq
      fd
      # --- REPLACE THIS ---
       plasma5Packages.kdeconnect-kde
      #indicator-kdeconnect # Provides a system tray icon for i3

      tmux
      lazygit
      lazydocker
      jetbrains-mono
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
      libimobiledevice
      ifuse
      vscode
      i3status-rust
    ] ++ (with unstable; [
      # Add unstable packages here, e.g., neovim
    ]);

    file.".config/alacritty/alacritty.toml".source = ./config/alacritty.toml;
  };

  # ... (keep the rest of your home.nix config)
}