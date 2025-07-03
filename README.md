
# Nova-Nix: My NixOS impl

This is my NixOS configuration repo. This setup powers my development machine, `nova-nix`, and is managed declaratively using Flakes and Home Manager. The goal is a reproducible, efficient, and secure environment tailored for software development on a Wayland-based desktop.

## System Philosophy

This is my second attempt at a stable NixOS installation. in the first one I used X11 With KDE Plasma 6.4. I loved it but!, likely because of my newness, I ended up configuring a ton of plasma features outside of my Nix manifest. WHen disaster occurred as it does, it was easy to restore my system but not Plasma. It was then that I decide to try Hyprland and made it a point to never open a settings applet or a dot file. so far I've been able to get configure Nova-Nix all through configuration I kept going back to the ideas in [Erase all your darlings](https://grahamc.com/blog/erase-your-darlings/)

I have used Google's Gemini (I call it **Lexx**) **EXTENSIVELY** to help me get this set up. it has been an invaluable resource most of the times, but when we fail, it is usually together. I would say that about 40% of the configuration work goes w/o a hitch, we have issues in about another 40% of the work, and often doing some side research and feeding Lexx up to date context gets the job done. About 20% of the rest it is either me implementing a solution or possibly pivoting or abandonning 

This configuration embodies several core principles:

*   **Declarative:** NixOS, from the nixos.org [website](https://nixos.org/manual/nixos/stable/#preface): NixOS, a Linux distribution based on the purely functional package management system Nix, that is composed using modules and packages defined in the Nixpkgs project.
*   **Reproducible:** Given the same hardware, this flake can rebuild the exact same system, ensuring consistency and easy recovery.
*   **Wayland First:** The graphical environment is built on Hyprland, a dynamic tiling Wayland compositor, for a modern and fluid user experience.
*   **Security-Minded:** Features like hardware-based 2FA for `sudo`, encrypted DNS, and system-wide ad-blocking are enabled by default.

## Core Components & Stack

Here's a high-level overview of the technologies that make up this system:

| Component             | Implementation                                                                                               |
| --------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Operating System**  | [NixOS](https://nixos.org/) 25.05 "Warbler"                                                                    |
| **Package Management**| [Nix Flakes](https://nixos.wiki/wiki/Flakes)                                                                   |
| **User Environment**  | [Home Manager](https://github.com/nix-community/home-manager)                                                  |
| **Window Manager**    | [Hyprland](https://hyprland.org/) (Wayland)                                                                    |
| **Display Manager**   | SDDM with the [Sugar Candy](https://gitlab.com/Zhaith-Izaliel/sddm-sugar-candy-nix) theme                        |
| **Terminal**          | [Alacritty](https://alacritty.org/) (GPU-accelerated)                                                          |
| **Shell**             | [NuShell](https://www.nushell.sh/)                                                                             |
| **Shell Prompt**      | [Starship](https://starship.rs/)                                                                               |
| **Multiplexer**       | [Zellij](https://zellij.dev/)                                                                                  |
| **Editor**            | [Visual Studio Code](https://code.visualstudio.com/)                                                           |
| **Primary Workload**  | .NET Development                                                                                             |

## Key Features & Configuration Details

### 1. Hardware & Drivers

*   **NVIDIA GPU:** Utilizes the proprietary NVIDIA `stable` drivers, specifically configured for optimal performance on Wayland/Hyprland. This includes setting `nvidia_drm.modeset=1` and essential environment variables (`GBM_BACKEND`, `__GLX_VENDOR_LIBRARY_NAME`) to ensure smooth hardware acceleration.
*   **Bluetooth:** `bluez` is enabled with `powerOnBoot`, and my Logitech MX Master 3 mouse is pre-configured to trust and auto-connect on startup.
*   **Audio:** Managed by **PipeWire**, providing modern, low-latency audio support for both native applications and PulseAudio/ALSA compatibility layers.

### 2. Security Enhancements

*   **YubiKey Authentication:** The system is configured to use a YubiKey (or any U2F device) for passwordless authentication. This is enforced via `pam_u2f` and is required for both graphical `login` and command-line `sudo` operations, significantly hardening the system against unauthorized access.
*   **Encrypted DNS (DNS-over-TLS):** Network lookups are secured using `stubby`, which routes DNS queries over TLS to Cloudflare's servers (`1.1.1.1`). This prevents DNS snooping and manipulation.
*   **System-Wide Ad-Blocking:** The [Steven Black hosts file](https://github.com/StevenBlack/hosts) is fetched declaratively during the system build and integrated into `/etc/hosts`, blocking ads and trackers across all applications.

### 3. Development Environment

*   **Tailored for .NET:** While .NET itself is installed via other means (like `asdf` or dev shells), the system provides all the necessary dependencies and tools.
*   **VS Code:** The primary editor, configured via Home Manager.
*   **Version Control:** A rich Git experience is configured with `git`, `gh` (GitHub CLI), `lazygit` (TUI), and `jujutsu` (an alternative Git-compatible VCS).
*   **Containerization:** `lazydocker` is included for easy management of Docker containers.
*   **Compatibility with AppImages/Binaries:** The `nix-ld` library loader is configured with a wide range of common libraries to ensure that pre-compiled applications (like those in AppImage format) run without issue.

### 4. CLI & User Experience

*   **Modern CLI Stack:** The combination of **Alacritty**, **NuShell**, **Starship**, and **Zellij** provides a powerful, modern, and visually appealing command-line experience.
*   **Essential Tools:** My environment is packed with modern CLI utilities like `eza` (a `ls` replacement), `bat` (a `cat` clone with syntax highlighting), `zoxide` (smarter `cd`), and `fzf` (fuzzy finder).
*   **Clipboard History:** `cliphist` is configured as a `systemd` user service, providing persistent clipboard history in a Wayland-native way.
*   **Modular Configuration:** Both the system (`configuration.nix`) and user (`home.nix`) files are broken down into smaller, self-contained modules (e.g., `vscode.nix`, `nushell.nix`), making the configuration easier to read, manage, and extend.

### 5. Future Plans

*   **ErgoDox Infinity Keyboard:** I recently acquired an ErgoDox Infinity keyboard. The next step for this configuration is to integrate tools for flashing and managing its firmware, likely using `pkgs.qmk` or `pkgs.wally-cli`.

## Repository Structure

```
.
├── flake.nix               # Main entrypoint, defines inputs and outputs
├── configuration.nix         # System-wide configuration (services, hardware, etc.)
├── hardware-configuration.nix # Auto-generated hardware profile
└── home-manager/
    ├── home.nix            # Home Manager root configuration for my user
    ├── config/
    │   └── alacritty.toml  # Symlinked Alacritty config
    └── modules/
        ├── vscode.nix      # VS Code specific settings and extensions
        ├── nushell.nix     # NuShell configuration
        └── ...             # Other modularized application configs
```

## Usage

**A word to the wise:** I've implemented several modules that I am no longer using or are in the messing with stage. check the imports section in [./home-manager/home.nix](https://github.com/ayrtons2k/nova-nix/blob/main/home-manager/home.nix), if a module is not referenced here I am not using it and you should be cautious when looking at it.

To deploy this configuration on a new machine:

1.  Clone this repository to `/etc/nixos/`.
2.  Review and adapt `hardware-configuration.nix` for the target machine.
3.  Modify the user and hostname (`ayrton`, `nova-nix`) as needed.
4.  Run the build and switch command:

```sh
# Build and apply the configuration
sudo nixos-rebuild switch --flake .#nova-nix
```

---

This README should serve as an excellent starting point for your repository. It not only lists your packages but also explains the rationale behind your architectural choices, making it valuable for both your future self and anyone else who might learn from your setup.

Now, let's talk about those upgrades. What are you looking to improve or change? We can discuss updating your channels, adding new services, or refining your existing configuration.