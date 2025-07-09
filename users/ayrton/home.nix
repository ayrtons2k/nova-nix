{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    ../../home/core.nix
    ../../modules/home/hyprland.nix
    ../../modules/home/vscode.nix
    ../../modules/home/nushell.nix
    ../../modules/home/starship.nix
    ../../modules/home/git.nix
    ../../modules/home/zellij.nix
    ../../modules/home/libre-office.nix
  ];

  programs.home-manager.enable = true;
  services.gnome-keyring.enable = true;
  programs.jujutsu.enable = true; 
  programs.ayrton.libreoffice.enable = true;

  xdg.portal = {
    enable = true;
    # On NixOS, you might prefer to set this in configuration.nix
    # but setting it here is also fine.
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    # This sets Hyprland as the default handler for portal requests
    config.common.default = "*";     
  };

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
      btop
      jq
      fd
      pdftk
      pdfcpu
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
      pkgs.gnome-keyring
      aichat
      pkgs.cliphist
      pkgs.wl-clipboard
      wget
      btop       
    ] ++ (with unstable; [
      # Add unstable packages here, e.g., neovim
    ]);

    file.".config/alacritty/alacritty.toml".source = ../../config/alacritty.toml;
  };

  # ... (keep the rest of your home.nix config)
}