# ~/obs-flake/flake.nix
{
  description = "A flake for running OBS Studio with content creation plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/nix-flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # --- List of OBS Native Plugins ---
        # Find more at: https://search.nixos.org/packages?query=obs-studio-plugins
        obs-plugins = with pkgs; [
          # Essential for remote control (e.g., via phone, Stream Deck)
          obs-websocket
          # Send video/audio sources over the network
          obs-ndi
          # Enables VST audio plugin support. CRITICAL for audio processing.
          obs-studio-plugins.obs-vst
          # Essential for capturing application audio on PipeWire systems
          obs-studio-plugins.obs-pipewire-audio-capture
          # A simple, but very useful, transition for moving sources
          obs-studio-plugins.obs-move-transition
          # AI-powered background removal without a green screen
          obs-studio-plugins.obs-backgroundremoval
          # Adds a dock for managing all your sources in one place
          obs-studio-plugins.obs-source-dock
          # Cool audio visualizer for music or "be right back" scenes
          obs-studio-plugins.obs-spectralizer
        ];

        # --- List of VST Audio Plugins for Microphone Control ---
        # These are used by the `obs-vst` plugin above.
        # Find more with `pkgs.vst3Plugins` or by searching for "vst"
        vst-plugins = with pkgs; [
          # The legendary ReaPlugs suite: EQ, Compressor, Gate, etc.
          # Essential for professional microphone sound.
          reaplugs
          # Excellent AI-based noise suppression VST
          noise-suppression-for-voice
        ];

        # Build a custom OBS package that includes all the native plugins
        obs-with-plugins = pkgs.obs-studio-full {
          plugins = obs-plugins;
        };

        # Helper to create the VST search paths
        vst-paths = pkgs.lib.makeSearchPath "lib/vst" vst-plugins;
        vst3-paths = pkgs.lib.makeSearchPath "lib/vst3" vst-plugins;

      in
      {
        # This package can be installed if you prefer, but the devShell is recommended
        packages.obs-pro = obs-with-plugins;

        # The primary way to use this flake: `nix develop`
        devShells.default = pkgs.mkShell {
          name = "obs-pro-shell";

          # Packages available in the shell
          buildInputs = [
            obs-with-plugins
          ] ++ vst-plugins;

          # Set environment variables so the obs-vst plugin can find our audio plugins
          shellHook = ''
            export VST_PATH="${vst-paths}"
            export VST3_PATH="${vst3-paths}"
            echo "--- OBS Development Shell ---"
            echo "OBS Studio is ready with all plugins."
            echo "VST Paths have been set for ReaPlugs and Noise Suppression."
            echo "Run 'obs' to start."
            echo "-----------------------------"
          '';
        };
      }
    );
}