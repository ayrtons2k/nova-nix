# ~/nova-nix-config/modules/nixos/dev-flakes/obs/flake.nix
{
  description = "A flake for running OBS Studio with content creation plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # 1. A list of NATIVE OBS plugins. We add them individually.
        #    You can verify each of these at search.nixos.org
        obs_native_plugins = with pkgs.obs-studio-plugins; [

          # Other useful plugins from your original request:
          obs-websocket
          obs-ndi
          obs-move-transition
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];

        # 2. A list of VST audio plugins for microphone control.
        audio_plugins_for_mic = [
          pkgs.lsp-plugins
        ];

        # 3. Create the search paths for our VST audio plugins.
        vst_paths = pkgs.lib.makeSearchPath "lib/vst" audio_plugins_for_mic;
        vst3_paths = pkgs.lib.makeSearchPath "lib/vst3" audio_plugins_for_mic;

      in
      {
        devShells.default = pkgs.mkShell {
          name = "obs-pro-shell";

          # We put the base OBS, all native plugins, and all VST plugins
          # together in the same environment.
          buildInputs = [
            pkgs.obs-studio
          ] ++ obs_native_plugins ++ audio_plugins_for_mic;

          # Set environment variables so `obs-vst` can find the LSP plugins.
          shellHook = ''
            export VST_PATH="${vst_paths}"
            export VST3_PATH="${vst3_paths}"
            echo "--- OBS Development Shell ---"
            echo "OBS Studio is ready with all plugins."
            echo "Audio plugin paths are set for LSP Plugins."
            echo "Run 'obs' to start."
            echo "-----------------------------"
          '';
        };
      }
    );
}