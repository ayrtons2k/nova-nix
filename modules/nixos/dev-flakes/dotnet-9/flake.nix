{
  description = ".NET 9 Development Environment with VS Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nova-nix-config.url = "path:/home/ayrton/nova-nix-config";
    nova-nix-config.flake = false;
  };

  outputs = { self, nixpkgs, nova-nix-config }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      dotnetSdkVersion = pkgs: pkgs.dotnet-sdk_9;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true;
          };
          dotnetSdk = dotnetSdkVersion pkgs;
          mkVscode = import "${nova-nix-config}/modules/editors/vscode" { inherit pkgs; };
          dotnet-vscode-extensions = with pkgs.vscode-extensions; [
            ms-dotnettools.csharp
            ms-dotnettools.csdevkit
            #formulahendry.dotnet-test-explorer
          ];
          dotnet-vscode = mkVscode { extensions = dotnet-vscode-extensions; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              dotnetSdk
              pkgs.git
              
              # --- THIS IS THE FIX ---
              # Use the dotnet-tools attribute set for .NET global tools
              #pkgs.dotnet-tools.format
              #pkgs.dotnet-tools.coverlet-console
              
              dotnet-vscode
            ];

            shellHook = ''
              echo "Welcome to the .NET 9 development environment!"
              echo "Using .NET SDK version: $(${dotnetSdk}/bin/dotnet --version)"
              echo "Visual Studio Code with .NET extensions is available."
              echo "---------------------------------------------------"
              unset SOURCE_DATE_EPOCH
            '';

            DOTNET_ROOT = "${dotnetSdk}";
            NUGET_PACKAGES = "${toString ./.}./.nuget/packages";
            DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          };
        }
      );
    };
}