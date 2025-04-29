#https://github.com/srid/nixos-config/tree/master/home
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dotnet-sdk_9 # Installs .NET 9.0 SDK
  ];

  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions;
      [
        adpyke.codesnap
        azsdktm.securityintellisense
        bbenoist.nix
        catppuccin.catppuccin-vsc-icons
        dracula-theme.theme-dracula
        eamodio.gitlens
        edwinsulaiman.jetbrains-rider-dark-theme
        enkia.tokyo-night
        esbenp.prettier-vscode
        eserozvataf.one-dark-pro-monokai-darker
        faceair.ayu-one-dark
        github.github-vscode-theme
        hbenl.vscode-test-explorer
        hediet.vscode-drawio
        hilalh.hyper-dracula-vscode-theme
        ionide.ionide-fsharp
        jmrog.vscode-nuget-package-manager
        kamadorueda.alejandra
        ms-dotnettools.blazorwasm-companion
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.dotnet-interactive-vscode
        ms-dotnettools.vscode-dotnet-pack
        ms-dotnettools.vscode-dotnet-runtime
        ms-dotnettools.vscodeintellicode-csharp
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.test-adapter-converter
        patcx.vscode-nuget-gallery
        redhat.java
        redhat.vscode-xml
        sallar.vscode-duotone-dark
        sandrorybarik.omnipotent
        saoudrizwan.claude-dev
        streetsidesoftware.code-spell-checker
        subframe7536.theme-maple
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        thomaz.preparing
        timheuer.resx-editor
        tion.evenbettercomments
        uloco.theme-bluloco-dark
        wart.ariake-dark
        yzhang.markdown-all-in-one
        zhuangtongfa.material-theme
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
}
/*
   settings
{
    "terminal.integrated.profiles.linux": {
        "Nushell": {
          "path": "nu",
        }
      },
    "security.workspace.trust.untrustedFiles": "open",
    "workbench.colorTheme": "Default Dark+",
    "workbench.settings.applyToAllProfiles": [
        "editor.fontSize"
    ],
    "files.autoSave": "afterDelay",
    "editor.fontSize": 13,
    "git.enableSmartCommit": true,
    "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
    "terminal.external.linuxExec": "nu.exe",
    "editor.codeLensFontFamily": "'JetBrains Mono Nerd Font'",
    "editor.fontFamily": "'JetBrainsMono Nerd Font', 'monospace', monospace",
    "terminal.integrated.fontSize": 12,
    "terminal.integrated.cursorBlinking": true,
    "terminal.integrated.cursorStyle": "underline",
    "terminal.integrated.defaultProfile.linux": "Nushell"
}
*/

