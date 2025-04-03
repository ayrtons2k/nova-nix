
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
in {

  
  imports = [
    ./modules/codium.nix
    ./modules/nushell.nix
    ./modules/git.nix
    ./modules/zellij.nix
  ];

  programs.home-manager.enable = true;

  home.username = "ayrton";
  home.homeDirectory = "/home/ayrton";
  home.stateVersion = "24.11"; # This version should match your NixOS version

  # fonts.fonts = with pkgs; [
  #   noto-fonts
  #   #dejavu-fonts
  #   google-fonts
  #   open-fonts
  #   input-fonts
  #   kreative-square-fonts    # https://www.kreativekorp.com/software/fonts/ksquare/
  #   typodermic-free-fonts             #https://typodermicfonts.com/
  #   # Add any other font packages you'd like
  # ];

  home.packages = with pkgs; [
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
    nerd-fonts.jetbrains-mono
   /*  nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.daddy-time-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.departure-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.inconsolata
    nerd-fonts.inconsolata-go
    nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab */
    jetbrains-mono
    /* nerd-fonts.lekton
    nerd-fonts.liberation
    nerd-fonts.lilex
    nerd-fonts.martian-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.mplus
    nerd-fonts.noto
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.shure-tech-mono
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
    noto-fonts
    #dejavu-fonts
    open-fonts
    #input-fonts
    kreative-square-fonts    # https://www.kreativekorp.com/software/fonts/ksquare/
    #typodermic-free-fonts  */ 
   


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
    ctranslate2
    opera
    libimobiledevice
    ifuse
    # cudatoolkit
    # customPkgs.lmstudio
  ] ++ (with unstable; [
    # Add unstable packages here
    # For example:
    # unstable.somePackage
  ]);

  programs = {
    carapace = {
      enable = true;
      # carapace.enableNushellIntegration = true;     # not working
    };
  

    #nerd-fonts_0xproto
    #nerd-fonts_3270
  
 


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
    # programs.zellij.enableNushellIntegration = true;

    eza = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
