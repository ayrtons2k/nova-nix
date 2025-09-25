# OBS Studio Pro Environment via Nix Flakes

This project provides a reproducible, self-contained development environment for running OBS Studio. It uses a Nix Flake to bundle OBS with a curated set of common plugins for professional podcasting, content creation, and high-quality microphone control.

The key benefit is that this entire setup is defined in a single `flake.nix` file. It will work identically on any machine with Nix installed, without polluting your global system configuration.

This directory is set up as a working environment. The `flake.nix` and `README.md` are symlinked from a central NixOS configuration repository, which is the single source of truth.

## Quick Start (with Direnv)

This directory is configured to use `direnv` for automatic environment loading.

**Prerequisites:** You must have `direnv` installed and [hooked into your shell](https://direnv.net/docs/hook.html).

1.  **Allow the environment:** The first time you enter this directory, you will need to grant `direnv` permission to load the environment:
    ```bash
    direnv allow .
    ```
    *(`direnv` will automatically start building the Nix environment. This may take a while on the first run.)*

2.  **That's it!** Now, whenever you `cd` into this directory, the Nix shell will be loaded automatically.

3.  **Launch OBS:**
    ```bash
    obs
    ```

When you `cd` out of the directory, the environment will be automatically unloaded.

## Manual Start (Without Direnv)

If you don't use `direnv`, you can always load the shell manually.

1.  **Enter the development shell:**
    ```bash
    nix develop
    ```
    *(The first time you run this, Nix will download and build all the specified packages. Subsequent runs will be instant.)*

2.  **Launch OBS:** Once inside the shell, launch OBS Studio:
    ```bash
    obs
    ```

## Features

This flake comes pre-loaded with the following plugins:

#### OBS Native Plugins
- **obs-websocket**: Essential for remote control (e.g., via Stream Deck, mobile apps).
- **obs-ndi**: Send high-quality, low-latency video and audio over your local network.
- **obs-vst**: Enables support for VST audio plugins, the key to professional audio.
- **obs-pipewire-audio-capture**: The modern way to capture desktop or application audio.
- **obs-move-transition**: A powerful and popular transition for animating sources between scenes.
- **obs-backgroundremoval**: AI-powered background removal without a green screen.
- **obs-source-dock**: A dock that lists all sources across all scenes for easy management.
- **obs-spectralizer**: A cool audio visualizer for music or "be right back" scenes.

#### Audio (VST) Plugins for Microphone Control
- **ReaPlugs**: A free, high-quality VST suite including:
  - **ReaEQ** (Equalizer)
  - **ReaComp** (Compressor)
  - **ReaGate** (Noise Gate)
- **noise-suppression-for-voice**: An excellent AI-based noise suppression plugin.

## Developing and Iterating on This Flake

The power of this setup is how easy it is to customize.

**Important:** The `flake.nix` file in this directory is a symlink. To make changes, you must edit the original source file located in your NixOS configuration repository (`.../nova-nix-config/modules/nixos/dev-flakes/obs/flake.nix`).

### 1. Finding New Plugins

The best place to find available Nix packages for OBS is the official NixOS package search:

- **[search.nixos.org](https://search.nixos.org/packages)**

Use the following search terms:
- For native OBS plugins: `obs-studio-plugins` or `obs-` followed by the plugin name.
- For audio plugins: `vstPlugins` or `vst3Plugins`.

### 2. How to Add or Remove a Plugin

1.  **Edit the source `flake.nix` file** and add or remove the desired package name from either the `obs-plugins` or `vst-plugins` list.
2.  **Save the file.**
3.  **Reload the environment:** If you are in the directory, `direnv` will detect the change to `flake.nix` and automatically start rebuilding the environment. You can also trigger it manually with `direnv reload`. If not using `direnv`, exit the shell and run `nix develop` again.

### 3. Updating All Plugins

Over time, you may want to update all the plugins to their latest versions as packaged in Nixpkgs. You can do this by updating the flake's inputs in your NixOS configuration repository:

```bash
# Navigate to the directory containing your primary flake (e.g., ~/nova-nix-config)
nix flake update