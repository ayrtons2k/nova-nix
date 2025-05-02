# Nova-Nix Configuration: Setup Journey & Lessons Learned

This document outlines the process and key decisions made while setting up the NixOS configuration managed in this repository (`nova-nix`). It serves as a log of the journey, highlighting challenges encountered and solutions implemented.

## System Overview

*   **Operating System:** NixOS ([Specify Version Used, e.g., 24.05 or 24.11])
*   **Management:** Nix Flakes & Home Manager
*   **Desktop Environment:** KDE Plasma 6
*   **Hardware:**
    *   CPU/Motherboard: [Specify if relevant]
    *   RAM: 32GB
    *   Storage: 2 x 1TB NVMe SSDs
    *   GPU: Nvidia [Specify Model if known]

## Goals

*   Create a reproducible, declarative NixOS configuration.
*   Utilize both NVMe drives effectively.
*   Configure a comfortable development environment with specific terminal setup.
*   Integrate Home Manager for user-level configuration.
*   Set up SSH agent integration for convenient Git/SSH usage.

## Phase 1: Installation & Partitioning

Choosing the right partitioning scheme for the two NVMe drives was the first step. Options considered included RAID 0 (capacity/speed, risky), RAID 1 (redundancy), and separate drives.

**Final Partitioning Scheme (GPT on both drives):**

*   **Drive 1 (`/dev/nvme0n1`): OS & Swap**
    *   `nvme0n1p1`: 1024 MiB, FAT32, Mount: `/boot`, Flags: `boot`, `esp` (Primary ESP)
    *   `nvme0n1p2`: 36864 MiB (36 GiB), Linux Swap (Sized for 32GB RAM + Hibernation buffer)
    *   `nvme0n1p3`: Remaining Space (~894 GiB), Btrfs, Mount: `/` (Root Filesystem)
*   **Drive 2 (`/dev/nvme1n1`): User Data & Redundant Boot**
    *   `nvme1n1p1`: 1024 MiB, FAT32, *No initial mount*, Flags: `boot`, `esp` (Backup ESP)
    *   `nvme1n1p2`: Remaining Space (~930 GiB), Btrfs, Mount: `/home`

**Reasoning:**
*   Provides boot redundancy via two ESPs.
*   Separates the core OS from user data (`/home`).
*   Adequate swap space for hibernation needs.
*   Avoids RAID complexity during initial install, leverages Btrfs features on root/home.

## Phase 2: Initial Boot & Troubleshooting

The first installation attempt resulted in a boot loop, returning directly to the BIOS/UEFI firmware.

The second attempt, after carefully applying the partitioning scheme, resulted in the system hanging during boot with the message:
`A start job is running for /dev/disk/by-uuid/[UUID corresponding to root partition] (xs / 1min 30s)`

This timed out, leading to dependency failures for `/data` (unexpected) and "Local File Systems", dropping the system into **emergency mode**.

**Recovery & Solution:**

1.  **Booting Previous Generation:** Fortunately, NixOS's generation management allowed booting into the *previous* working generation (likely the base installer generation or an intermediate successful build). This provided a functional environment for diagnosis.
2.  **Identifying the Cause:**
    *   Checked `/etc/nixos/hardware-configuration.nix`.
    *   Found the UUID listed for `fileSystems."/"` did **not** match the actual UUID of the root partition (`/dev/nvme0n1p3`) as shown by `lsblk -f`.
    *   Found an erroneous entry for `fileSystems."/data"` which did not correspond to any intentionally created partition or subvolume.
3.  **Applying the Fix:**
    *   Corrected the UUID for `fileSystems."/"` in `hardware-configuration.nix`.
    *   Removed the entire `fileSystems."/data"` block.
4.  **Rebuilding:** Ran `sudo nixos-rebuild switch --flake .#nixos` (or relevant hostname) from the working previous generation.
5.  **Success:** The subsequent reboot successfully mounted all filesystems and booted into the configured Plasma desktop.

**Key Takeaway:** Incorrect filesystem UUIDs or unexpected filesystem entries in the NixOS configuration are critical boot failures. Previous generations are invaluable for recovery.

## Phase 3: Base Configuration & Nvidia Drivers

*   Established base `configuration.nix` with Plasma 6, Pipewire, NetworkManager, etc.
*   Added Nvidia proprietary drivers using the `hardware.nvidia` options:
    ```nix
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true; # For compatibility
    };
    ```
*   Ensured `nixpkgs.config.allowUnfree = true;` was set.
*   Encountered and resolved a temporary build error related to the deprecated `hardware.opengl.driSupport` option by removing it.

## Phase 4: Setting up `nova-nix` Repo & Home Manager

1.  **SSH Key for GitHub:** Generated a new `ed25519` SSH key using `ssh-keygen` and added the public key to GitHub account settings.
2.  **Cloned Repo:** Cloned the `nova-nix` configuration repository from GitHub using the SSH URL.
3.  **Home Manager Integration:**
    *   Added `home-manager` as an input to `flake.nix`, ensuring it `follows` the primary `nixpkgs` input.
    *   Added the `home-manager.nixosModules.home-manager` module to the NixOS configuration modules list in `flake.nix`.
    *   Configured the integration within the system modules:
        ```nix
        home-manager.users.ayrton = import ./home.nix; // Or path/to/home.nix
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; }; // Pass flake inputs if needed
        ```
    *   Created `home.nix` to define user packages, dotfiles, services, etc.

## Phase 5: Custom Terminal & SSH Agent

**Goal:** Default terminal: Alacritty launching Zellij, running Nushell. SSH key auto-added without constant passphrase prompts.

1.  **Terminal Setup:**
    *   Installed `alacritty`, `zellij`, `nushell` via `home.packages`.
    *   Set Nushell as the default login shell via `users.users.ayrton.shell = pkgs.nushell;` in `configuration.nix`.
    *   Managed `alacritty.toml` using `home.file`:
        ```nix
        # In home.nix
        home.file.".config/alacritty/alacritty.toml".source = ./path/to/alacritty.toml;
        programs.alacritty.enable = true; // For .desktop file etc.
        # Ensured alacritty.toml contained [shell] program = "zellij"
        ```
    *   Set Alacritty as the default terminal in KDE System Settings (manual step, could use `kwriteconfig` activation script).

2.  **SSH Agent Setup (GPG Agent Method):**
    *   Avoided KDE Wallet integration for a CLI-focused approach.
    *   Disabled `programs.ssh` in `home.nix`.
    *   Enabled and configured `services.gpg-agent`:
        ```nix
        # In home.nix
        services.gpg-agent = {
          enable = true;
          enableSshSupport = true;
          pinentryPackage = pkgs.pinentry-tty; // CLI passphrase prompt
          defaultCacheTtl = 3600;
          maxCacheTtl = 7200;
          sshKeys = [ "/home/ayrton/.ssh/id_ed25519" ];
        };
        ```
    *   **Troubleshooting Auto-Add:** Realized `gpg-agent` doesn't automatically trigger `ssh-add` on startup in a way that prompts for the passphrase if needed. Added conditional logic to Nushell's `extraConfig` in `home.nix` (managed via the `nushell.nix` module):
        ```nix
        # Inside programs.nushell.extraConfig
        ssh-add -l | find ~/.ssh/id_ed25519 | ignore
        if $env.LAST_EXIT_CODE != 0 {
            print "Attempting to add SSH key to agent..."
            ssh-add ~/.ssh/id_ed25519 | ignore
        }
        ```
        This checks if the key is loaded on shell startup and only runs `ssh-add` (triggering pinentry) if it's not found, preventing repeated prompts in new terminals within the cache TTL.

## Final Lessons & Takeaways

*   **UUIDs are Critical:** Double-check filesystem UUIDs in NixOS configuration, especially after partitioning or changes.
*   **Declarative Pitfalls:** Ensure configuration blocks are nested correctly (e.g., `home.file` belongs under `home`, not `programs.alacritty`). Typos or incorrect options can lead to non-obvious boot failures.
*   **Generations are Lifesavers:** The ability to boot into a previous, working generation is invaluable for diagnosing and fixing broken configurations.
*   **Shell Startup Logic:** Actions intended to run automatically on shell startup (like `ssh-add`) need careful conditional logic to avoid running unnecessarily or incorrectly in subsequent shell instances. Check exit codes or use robust tests.
*   **Agent Integration:** Understand how different agents (`ssh-agent`, `gpg-agent`) and passphrase managers (KDE Wallet, pinentry) interact. Choose the method that fits the desired workflow (GUI vs CLI).

This setup provides a solid, reproducible base for development on NixOS, leveraging Flakes and Home Manager for comprehensive system and user configuration.