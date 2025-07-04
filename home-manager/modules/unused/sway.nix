{ pkgs, ... }:

let
  myTerminal = "alacritty";
  myUser = "ayrton";

  sway-screenshot-wrapper = pkgs.writeShellScriptBin "sway-screenshot-wrapper" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  home.packages = with pkgs; [
    i3status-rust
    brightnessctl
    sway-screenshot-wrapper
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = myTerminal;

      bars = [ { command = "${pkgs.i3status-rust}/bin/i3status-rust -c /home/${myUser}/.config/i3status-rust/config.toml"; } ];
      gaps = { inner = 10; outer = 5; };
      startup = [
        { command = "nm-applet"; }
        { command = "blueman-applet"; }
        { command = "kdeconnect-indicator"; }
      ];

      fonts = { names = [ "JetBrains Mono" ]; size = 10.0; };
      # colors = {
      #   background = "#282828";
      #   focused = { background = "#3c3836"; border = "#fabd2f"; childBorder = "#fabd2f"; indicator = "#fabd2f"; text = "#ebdbb2"; };
      #   unfocused = { background = "#282828"; border = "#504945"; childBorder = "#504945"; indicator = "#504945"; text = "#a89984"; };
      # };
      input = {
        "*" = { accel_profile = "flat"; };
        "type:touchpad" = { dwt = "enabled"; tap = "enabled"; };
      };
      output."*" = { 
        resolution = "5120x1440@119.986Hz";
        scale = "1.0";
        bg = "${../../wallpapers/i3wm-nova-nix.png} fill"; 

      };

      keybindings = {
        # Window & App Management
        "${modifier}+Return" = "exec ${myTerminal}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec wofi --show drun";
        "${modifier}+Shift+l" = "exec swaylock -f -c 000000";

        # Sway Session Management
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "mode 'resize'";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut...' -B 'Yes, exit Sway' 'swaymsg exit'";

        # --- WORKSPACE BINDINGS ARE NOW HERE ---
        "${modifier}+1" = "workspace 1";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+Shift+5" = "move container to workspace 5";

        # Function & Multimedia Keys
        "Print" = "exec sway-screenshot-wrapper";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };

      modes = {
        resize = {
          "h" = "resize shrink width 10px"; "j" = "resize grow height 10px"; "k" = "resize shrink height 10px"; "l" = "resize grow width 10px";
          "Left" = "resize shrink width 10px"; "Down" = "resize grow height 10px"; "Up" = "resize shrink height 10px"; "Right" = "resize grow width 10px";
          "Return" = "mode 'default'"; "Escape" = "mode 'default'";
        };
      };
    };

    # extraConfig is now perfectly minimal, as it should be.
    extraConfig = ''
      # Explicitly set the resolution for your monitor.
      output DP-2 resolution 5120x1440@120Hz

      # Window assignment and floating rules.
      assign [class="^firefox$"] → 2
      assign [class="^code$"] → 3
      for_window [class="Pavucontrol"] floating enable
      for_window [class="blueman-manager"] floating enable
      for_window [title="alsamixer"] floating enable
    '';
  };

  home.file.".config/i3status-rust/config.toml".source = ../config/i3status-rust.toml;
}