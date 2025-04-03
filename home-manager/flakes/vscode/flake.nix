{
  description = "A flake for installing VSCodium with popular extensions.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # or for more stability, specify a release
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Use vscodium as a default, as you may not want telemetry
    # If you prefer VS Code, you can change this to vscode and also
    #  change the 'package' definition in the outputs
    vscodium.url = "github:VSCodium/vscodium";
  };

  outputs = { self, nixpkgs, vscodium, ... }:
    let
      system = "x86_64-linux";  # or "aarch64-linux", etc.
      pkgs = import nixpkgs { inherit system; };
      # VS Code / VSCodium package to use
      # Replace with `pkgs.vscode` if you use VS Code
      vscode-package = vscodium.packages.${system}.vscodium;
    in {
      packages.${system}.vscodium-with-extensions = vscode-package.override {
        extensions = with pkgs.vscode-extensions; [
          # General / UI
          vscode-icons                 # File icon theme
          # ms-vscode.theme-darcula     # Example Dark Theme, You can choose a theme.
          # You can find themes on the marketplace.
          # You should install a theme for a good experience.
          # Coding related extensions
          ms-dotnettools.csharp       # C#
          esbenp.prettier-vscode      # Prettier (Code Formatter)
          rust-analyzer               # Rust Language Support
          ms-python.python            # Python
          dbaeumer.vscode-eslint      # ESLint (JavaScript/TypeScript Linter)
          # You will need a eslint config file or the linter may not work.
          # Example: https://eslint.org/docs/latest/use/configure
          # React / JavaScript / TypeScript
          vscode-styled-components   # Styled Components support
          # You can install the React plugin, but be sure you have an eslint configuration.
          dbaeumer.vscode-eslint        # ESLint for React/JS/TS (consider using a more specific plugin)
          # esbenp.prettier-vscode       # Prettier (Code Formatter)
          # React Snippets
          # You can include a code snippets plugin.
          # dsznajder.es7-react-js-snippets
          # You can enable it for just JS/TS and JSX/TSX.
          #  Example: https://code.visualstudio.com/docs/editor/userdefinedsnippets
          # Extensions from Hackr.io article
          # General
          # ms-vscode.vscode-typescript-tslint-plugin #This package is deprecated.  Recommend removing it
          # You will need to find an alternative
          # ms-vsliveshare.vsliveshare
          # You will need to log in.
          # Editor related
          editorconfig.editorconfig # EditorConfig for VS Code
          # Code formatting, has prettier
          # You should only use one code formatter
          # ecmel.vscode-html-css-class-completion # HTML/CSS Class Completion
          # ms-vscode.wordcount #Wordcount
          # vscjava.vscode-java-debug # Java Debugger
          # You might want to enable this if you are using java.
          # dbaeumer.vscode-eslint # for more linters

          # Other Useful Extensions.
          # You should use a theme for a better experience
          # Github Themes.
          # github.github-vscode-theme
          # For Go
          # golang.go
          #  For PHP
          #  bmewburn.vscode-intelephense-client # PHP intellisense
          #  For C++
          #  ms-vscode.cpptools

          #  Some other useful extensions
          #  ms-toolsai.jupyter
          #  formulahendry.auto-rename-tag
          #  Gruntfuggly.todo-tree
        ];
      };

      # You can also create a shell environment with vscode and its extensions
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (self.packages.${system}.vscodium-with-extensions)
          # You can include other tools here, like nodejs or rust
          # pkgs.nodejs_latest
          # pkgs.rustup
        ];
      };
    };
}