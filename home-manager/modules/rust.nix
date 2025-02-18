{ config, pkgs, lib, ... }:

{
  options.services.rust = {
    enable = lib.mkEnableOption "Install and configure Rust toolchain.";

    # Optionally specify a rustup profile.  If omitted, "default" is used.
    profile = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Rustup profile to use.";
    };

    # Optionally specify a rust version.  If omitted, latest stable is used.
    rustVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Rust version to install (e.g., stable, nightly, 1.65.0).  If null, uses the latest stable.";
    };

    # Optionally specify extra components to install.
    components = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of Rust components to install (e.g., rust-src, clippy, rustfmt).";
    };
  };

  config = lib.mkIf config.services.rust.enable {
    environment.systemPackages = [ pkgs.rustup ];

    systemd.services.rust-install = {
      description = "Install Rust toolchain";
      after = [ "network.target" ]; # Ensure network is up before installing
      wants = [ "network.target" ]; # Try to start if network starts
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 0;
      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Can be changed for specific users if needed.  Be careful about permissions.
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "install-rust" ''
          set -euo pipefail

          # Function to install rust and components
          install_rust() {
            if ! command -v rustup &> /dev/null; then
              echo "rustup not found. Installing..."
              curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
              source "$HOME/.cargo/env"
            fi

            echo "Using rustup profile: ${config.services.rust.profile}"
            rustup default ${config.services.rust.profile}

            if [[ "${config.services.rust.rustVersion}" != "null" ]]; then
              echo "Installing Rust version: ${config.services.rust.rustVersion}"
              rustup install ${config.services.rust.rustVersion}
              rustup default ${config.services.rust.rustVersion}
            else
              echo "Installing latest stable Rust version."
              rustup install stable
              rustup default stable
            fi

            echo "Installing additional components: ${lib.concatStringsSep " " config.services.rust.components}"
            for component in ${lib.concatStringsSep " " config.services.rust.components}; do
              rustup component add "$component"
            done
          }

          # Switch to root to install rust for the system (adjust as needed)
          su - root -c "install_rust"

          echo "Rust installation complete."
        '';
      };
    };
  };
}
content_copy
download
Use code with caution.
Nix

Explanation:

options.services.rust: This defines the options that users of this module can set. It uses lib.mkEnableOption to provide an enable option for controlling whether the Rust installation is enabled. It also defines options for profile, rustVersion, and components.

config = lib.mkIf config.services.rust.enable { ... }: This ensures that the configuration within this block is only applied when the services.rust.enable option is set to true.

environment.systemPackages = [ pkgs.rustup ];: This installs the rustup package as a system-wide package.

systemd.services.rust-install = { ... };: This defines a systemd service named rust-install.

description = "Install Rust toolchain";: A description of the service.

after = [ "network.target" ];: Specifies that the service should start after the network.target is reached, ensuring network connectivity.

wants = [ "network.target" ];: Suggests systemd to start the service together with network.target. If network.target fails, this service is not automatically stopped.

wantedBy = [ "multi-user.target" ];: Specifies that the service should be started when the system reaches the multi-user.target, which is the normal graphical or multi-user console login state.

startLimitIntervalSec = 0;: Prevents the service from being rate-limited by systemd if it fails to start multiple times in quick succession. This is useful if the initial installation fails due to transient network issues, for example.

serviceConfig = { ... };: Contains the configuration settings specific to the service.

Type = "oneshot";: Indicates that this service is a one-time execution and not a long-running process.

User = "root";: This runs the service as the root user, which is often necessary for system-wide installations. Important: Use with caution. If you only need Rust for a specific user, you should change this to that user.

RemainAfterExit = true;: Keeps the service in the "active" state even after the ExecStart command has completed. This is important because systemd doesn't automatically run the service again after a system update unless you take steps to trigger it.

ExecStart = pkgs.writeShellScript "install-rust" '' ... '';: This defines the shell script that will be executed when the service starts.

pkgs.writeShellScript "install-rust" '' ... '';: This creates a shell script containing the Rust installation logic.

set -euo pipefail: These options make the script more robust:

-e: Exit immediately if a command exits with a non-zero status.

-u: Treat unset variables as an error.

-o pipefail: If a command in a pipeline fails, the pipeline fails.

install_rust() { ... }: This defines a shell function to encapsulate the Rust installation logic.

if ! command -v rustup &> /dev/null; then ... fi: Checks if rustup is already installed. If not, it downloads and installs it.

source "$HOME/.cargo/env": Sources the environment variables set by rustup (after installation) so that cargo and other Rust tools are available in the PATH.

rustup default ${config.services.rust.profile}: Set the default profile.

if [[ "${config.services.rust.rustVersion}" != "null" ]]; then ... else ... fi: Installs the specified Rust version (if provided) or the latest stable version.

rustup component add "$component": Installs any additional components specified in the components option.

su - root -c "install_rust": This line is crucial. It uses su to switch to the root user and execute the install_rust function as root. This is usually required for system-wide Rust installations. If you want to install it just for your user you can change this to su - <username> -c "install_rust" replacing <username> with your username.

echo "Rust installation complete.": Prints a message indicating that the installation is finished.

How to Use This Module:

Save the code as a .nix file (e.g., rust.nix) in a suitable location (e.g., modules/).

Import the module in your configuration.nix:

{ config, pkgs, ... }:

{
  imports =
    [
      ./modules/rust.nix # Adjust path as needed
    ];

  services.rust.enable = true;

  # Optionally, customize the installation:
  # services.rust.profile = "default";  # or "minimal" or "complete"
  # services.rust.rustVersion = "stable";   # or "nightly" or "1.65.0"
  services.rust.components = [ "rust-src" "clippy" "rustfmt" ];
}
content_copy
download
Use code with caution.
Nix

Rebuild your system:

sudo nixos-rebuild switch
content_copy
download
Use code with caution.
Bash

Important Considerations:

User Context: The User = "root" in the systemd.service section means the Rust toolchain will be installed system-wide. This is generally what you want for a NixOS system. If you need Rust only for a specific user, change the User and su commands accordingly. Be very careful about permissions if you are running as the root user.

Network Access: The service depends on network connectivity (after = [ "network.target" ]).

rustup Updates: This module handles the initial Rust installation. rustup itself will handle updating Rust to newer versions. You can periodically run rustup update manually or create a separate systemd timer to automate Rust updates.

Security: Running code as root should be done with caution. Review the script carefully to ensure it's secure and only performs necessary actions.

Customization: The options.services.rust provides flexibility in configuring the installation (profile, version, components). Adjust these options to suit your specific needs.

Idempotency: The script checks if rustup is already installed. However, you might want to add more checks to make the script truly idempotent (e.g., check if the desired Rust version is already installed before attempting to install it again).

This comprehensive explanation and well-structured NixOS module will help you easily install and manage Rust on your NixOS system. Remember to adapt the user context to your specific needs and keep the security considerations in mind.