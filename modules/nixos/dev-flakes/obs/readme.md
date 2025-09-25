# OBS Studio Pro Environment via Nix Flakes

This project provides a reproducible, self-contained development environment for running OBS Studio. It uses a Nix Flake to bundle the base `obs-studio` package with a curated set of individual plugins for professional podcasting and content creation.

The key benefit is that this entire setup is defined in a single `flake.nix` file. It will work identically on any machine with Nix installed, without polluting your global system configuration.

This directory is set up as a working environment. The `flake.nix` and `README.md` are symlinked from a central NixOS configuration repository, which is the single source of truth.

## Quick Start (with Direnv)

This directory is configured to use `direnv` for automatic environment loading.

**Prerequisites:** You must have `direnv` installed and [hooked into your shell](https://direnv.net/docs/hook.html).

1.  **Allow the environment:** The first time you enter this directory, grant `direnv` permission:

    ```bash
    direnv allow .
    ```

    _(The first time you run this, Nix will build the environment, which may take a few minutes.)_

2.  **That's it!** Now, whenever you `cd` into this directory, the Nix shell will be loaded automatically.

3.  **Launch OBS:**
    ```bash
    obs
    ```

When you `cd` out of the directory, the environment will be automatically unloaded.

## Features

This flake provides the base `obs-studio` package and bundles the following plugins:

#### Native OBS Plugins

- **`obs-vst`**: The essential plugin that enables support for VST audio plugins, the key to professional microphone control.
- **`obs-websocket`**: For remote control of OBS (e.g., via Stream Deck, mobile apps).
- **`obs-ndi`**: Send high-quality video/audio over your local network.
- **`obs-move-transition`**: A popular transition for animating sources.
- **`obs-backgroundremoval`**: AI-powered background removal without a green screen.
- **`obs-pipewire-audio-capture`**: The modern way to capture desktop or application audio.

#### Audio (VST) Plugins for Microphone Control

- **`lsp-plugins`**: A large, professional suite of open-source VST audio plugins. This provides all the tools you need for microphone processing, including:
  - Parametric Equalizer
  - Compressor
  - Noise Gate
  - De-esser, and many more.

## Developing and Iterating on This Flake

The power of this setup is how easy it is to customize by adding or removing individual packages from lists in the `flake.nix` file.

**Important:** Edit the original `flake.nix` file in your NixOS configuration repository, not the symlink.

### 1. Finding New Plugins

The best place to find packages is the official NixOS package search. **This is the source of truth.**

- **[search.nixos.org](https://search.nixos.org/packages)**

Use the following search terms:

- For native OBS plugins: **`obs-studio-plugins`** (the packages will be named like `obs-studio-plugins.plugin-name`).
- For VST audio plugins: **`lsp-plugins`**, **`calf`**, or search for other VST packages.

### 2. How to Add or Remove a Plugin

Open your `flake.nix` and find the relevant list:

- **To add a native OBS plugin** (e.g., `obs-gstreamer`):
  Add `obs-studio-plugins.obs-gstreamer` to the `obs_native_plugins` list.

- **To add a VST audio plugin** (e.g., `calf`):
  Add `pkgs.calf` to the `audio_plugins_for_mic` list.

After saving the file, run `direnv reload` in this directory to have Nix build the new environment.

### 3. Updating All Plugins

To update all packages to their latest versions, run the update command from your main configuration repository:

```bash
# Navigate to the root of your config repo (e.g., ~/nova-nix-config)
nix flake update
```
