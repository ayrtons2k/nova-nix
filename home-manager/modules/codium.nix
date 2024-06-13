#https://github.com/srid/nixos-config/tree/master/home
{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions;
      [
        eamodio.gitlens
        yzhang.markdown-all-in-one
        bbenoist.nix
        catppuccin.catppuccin-vsc-icons
        redhat.java
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        yzhang.markdown-all-in-one
        hediet.vscode-drawio
        adpyke.codesnap
        streetsidesoftware.code-spell-checker
        esbenp.prettier-vscode
        kamadorueda.alejandra
        # bbenoist.Nix
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
        #
        # GitHub.vscode-pull-request-github
        # ms-toolsai.jupyter
        # arzg.intellij-theme
        # codemos.codemos-modern
        # deimonn.oro-theme
        # enkia.tokyo-night
        # huytd.tokyo-city
        # mads-hartmann.bash-ide-vscode
        # miguelsolorio.fluent-icons
        # monokai.theme-monokai-pro-vscode
        # realeinar.theme-dracula-midnight
        # abelfubu.abelfubu-dark
        # GrapeCity.gc-excelviewer
        # vsls-contrib.codetour
        # RandomFractalsInc.vscode-data-preview
        # wayou.vscode-todo-highlight
        # PKief.material-icon-theme
        # mangeshrex.Everblush
        # TabNine.tabnine-vscode
        # ms-python.python
        # ms-azuretools.vscode-docker
      ];
  };

  # home.packages = with pkgs; [
  #   (vscode-with-extensions.override {
  #   vscode = vscodium;
  #   vscodeExtensions = with vscode-extensions; [
  #     GrapeCity.gc-excelviewer
  #     vsls-contrib.codetour
  #     RandomFractalsInc.vscode-data-preview
  #     wayou.vscode-todo-highlight
  #     PKief.material-icon-theme
  #     hediet.vscode-drawio
  #     adpyke.codesnap
  #     streetsidesoftware.code-spell-checker
  #     esbenp.prettier-vscode
  #     mangeshrex.Everblush
  #     alexravenna.monokai-dimmed-vibrant
  #     TabNine.tabnine-vscode
  #     bbenoist.nix
  #     ms-python.python
  #     ms-azuretools.vscode-docker
  #    ]
  # })           # open source vs code clone w/o telemetry
  # ];
}
