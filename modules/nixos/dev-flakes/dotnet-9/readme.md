# .NET 9 Development Environment with Nix Flake

This repository provides a reproducible and self-contained development environment for .NET projects using a Nix Flake and direnv. It is configured to use the latest .NET 9 SDK.

## Quick Start

1.  **Prerequisites**: Ensure you have Nix (with Flakes enabled) and `direnv` installed on your system.
2.  **Clone this setup**: Copy the `flake.nix` and `.envrc` files into your project's root directory.
3.  **Allow direnv**: In your terminal, navigate to the project directory and run `direnv allow`.

This command instructs `direnv` to read the `.envrc` file and build the Nix environment. The initial build might take some time as it downloads the specified .NET SDK and tools. Subsequent loads will be much faster.

Once complete, your shell will have the .NET 9 SDK and all specified tools available.

## Key Features

- **Latest .NET SDK**: The environment is based on the **.NET 9 SDK**.
- **Essential Tooling Included**:
  - `git`: For source control management.
  - `dotnet-format`: A code formatter for keeping your C# code consistent.
  - `coverlet-console`: A cross-platform code coverage tool for your tests.
- **Fully Reproducible Dependencies**:
  - **Local NuGet Cache**: NuGet packages are stored in a `./.nuget/packages` directory within your project, ensuring that dependencies are completely self-contained and consistent across different machines and CI/CD.
  - **Pinned Nix Dependencies**: The `flake.lock` file (generated on first run) ensures that all developers use the exact same versions of every system-level package.
- **Best-Practice Environment Configuration**:
  - `DOTNET_ROOT` is explicitly set for maximum compatibility with .NET-aware tooling.
  - .NET CLI telemetry is disabled by default to respect your privacy (`DOTNET_CLI_TELEMETRY_OPTOUT=1`).

## Developing and Iterating

The power of Nix Flakes lies in how easy they are to modify and adapt.

### Changing the .NET SDK Version

To switch to a different version of the .NET SDK (e.g., to revert to .NET 8 LTS), you only need to make a small change in `flake.nix`.

1.  **Find the SDK package**: Search for the desired SDK on the [NixOS Packages website](https://search.nixos.org/packages). For example, the package for .NET 8 is `dotnet-sdk_8`.
2.  **Edit `flake.nix`**: Change the `dotnetSdkVersion` line to point to the new package:

    ```nix
    # ...
      # The .NET SDK version to use
      dotnetSdkVersion = pkgs: pkgs.dotnet-sdk_8; # Changed from pkgs.dotnet-sdk_9
    # ...
    ```

3.  **Reload the environment**: Direnv will automatically detect the change and rebuild the shell when you return to the directory.

### Adding More .NET Tools

You can easily add any .NET tool that is packaged in Nixpkgs.

1.  **Find the tool's package name**: Search for it on the [NixOS Packages website](https://search.nixos.org/packages).
2.  **Add to `buildInputs`**: Add the package name to the `buildInputs` list in your `flake.nix`:

    ```nix
    # ...
    buildInputs = [
      dotnetSdk
      pkgs.git
      pkgs.dotnet-format
      pkgs.coverlet-console
      pkgs.new-dotnet-tool # Add the new tool's package name here
    ];
    # ...
    ```

3.  Save the file, and `direnv` will handle the rest.
