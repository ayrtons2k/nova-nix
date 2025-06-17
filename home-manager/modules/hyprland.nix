{ pkgs, ... }:

# in your flake.nix

# ... (your existing `let` block with pkgs, myTerminal, etc. goes here)
# I fixed a small typo in your screenshot-wrapper script (missing semicolon)
let
  myTerminal = "alacritty";
  myUser = "ayrton";

  screenshot-wrapper = pkgs.writeShellScriptBin "screenshot-wrapper" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  ''; # <--- THIS SEMICOLON WAS MISSING

  hyprland-bar-wrapper = pkgs.writeShellScriptBin "hyprland-bar-wrapper" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.sway}/bin/swaybar --status-command "${pkgs.i3status-rust}/bin/i3status-rs -c /home/${myUser}/.config/i3status-rust/config.toml"
  '';
in
{
  # --- ADD THE WAYBAR CONFIGURATION +++
  programs.waybar = {
    enable = true;
    # Tell Waybar where to find its stylesheet
    style = ./../config/waybar.css;
    # Define the bar's layout and modules
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "pulseaudio" "network" "cpu" "memory" ];

        # Module-specific settings
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "default" = "";
          };
        };
        
        "clock" = {
          format = " {:%a %d %b %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ "" "" ];
          };
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "Disconnected";
        };
        
        "cpu" = {
          format = "  {usage}%";
        };

        "memory" = {
          format = " {}%";
        };
      };
    };
  };

  # The Home Manager module for Hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    # We use a `let` block for clarity and to avoid repeating "SUPER"
    # This makes the config much easier to read and modify.
    settings = let
      # Set the Super key (Windows key) as our main modifier
      mainMod = "SUPER";
    in {
      # --- MONITOR AND STARTUP ---
      monitor = "DP-2, 5120x1440@120, 0x0, 1";
      "exec-once" = [
        "hyprpaper -c ~/.config/hypr/hyprpaper.conf"
        "nm-applet"
        "blueman-applet"
        "kdeconnect-indicator"
      ];

      # --- INPUT AND GENERAL ---
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 10;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(fabd2f)";
        "col.inactive_border" = "rgb(504945)";
        layout = "dwindle";
      };

      # --- DECORATION AND ANIMATION ---
      decoration = {
        rounding = 10;
        blur.enabled = true;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # --- MOUSE BINDINGS ---
      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      # --- KEYBINDINGS ---
      bind = [
        # -----------------------------------------------------
        # -- Apps & Core Window Management
        # -----------------------------------------------------
        "${mainMod}, RETURN, exec, ${myTerminal}"
        "${mainMod} SHIFT, Q, killactive,"
        "${mainMod}, D, exec, wofi --show drun"
        "${mainMod}, V, togglefloating," # Toggle window between tiled and floating
        "${mainMod}, F, fullscreen,"     # Toggle fullscreen

        # -----------------------------------------------------
        # -- Focus & Tiled Window Movement
        # -----------------------------------------------------
        # Move focus with arrow keys
        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"

        # Swap window with another tiled window
        "${mainMod} SHIFT, left, movewindow, l"
        "${mainMod} SHIFT, right, movewindow, r"
        "${mainMod} SHIFT, up, movewindow, u"
        "${mainMod} SHIFT, down, movewindow, d"

        # -----------------------------------------------------
        # -- Tiled Window Resizing
        # -----------------------------------------------------
        # Resize active window
        "${mainMod} CONTROL, left, resizeactive, -20 0"
        "${mainMod} CONTROL, right, resizeactive, 20 0"
        "${mainMod} CONTROL, up, resizeactive, 0 -20"
        "${mainMod} CONTROL, down, resizeactive, 0 20"

        # -----------------------------------------------------
        # -- Layout & Grouping
        # -----------------------------------------------------
        "${mainMod}, J, togglesplit," # Toggle between vertical and horizontal split
        "${mainMod}, G, togglegroup," # Create/remove a group (tabbed layout)
        "${mainMod}, tab, changegroupactive, f" # Cycle through windows in a group

        # -----------------------------------------------------
        # -- Workspace Management
        # -----------------------------------------------------
        # Switch to workspace
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"

        # Move active window to workspace
        "${mainMod} SHIFT, 1, movetoworkspace, 1"
        "${mainMod} SHIFT, 2, movetoworkspace, 2"
        "${mainMod} SHIFT, 3, movetoworkspace, 3"
        "${mainMod} SHIFT, 4, movetoworkspace, 4"
        "${mainMod} SHIFT, 5, movetoworkspace, 5"
        "${mainMod} SHIFT, 6, movetoworkspace, 6"
        "${mainMod} SHIFT, 7, movetoworkspace, 7"
        "${mainMod} SHIFT, 8, movetoworkspace, 8"
        "${mainMod} SHIFT, 9, movetoworkspace, 9"
        "${mainMod} SHIFT, 0, movetoworkspace, 10"
        
        # Scroll through existing workspaces
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"

        # -----------------------------------------------------
        # -- System, Session & Media
        # -----------------------------------------------------
        # Session
        "${mainMod} SHIFT, L, exec, hyprlock"
        "${mainMod} SHIFT, C, exec, hyprctl reload"
        "${mainMod} SHIFT, E, exit,"
        "${mainMod} SHIFT, S, exec, systemctl suspend"

        # Media Keys (no modifier needed)
        ", Print, exec, screenshot-wrapper"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # --- WINDOW RULES ---
      windowrulev2 = [
        "workspace 2, class:^(firefox)$"
        "workspace 3, class:^(Code)$" # Note: VSCode class is often capitalized
        "float, class:^(Pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(alsamixer)$"
      ];
    };
  };
  home.file.".config/hypr/hyprpaper.conf".source = ./../config/hyprpaper.conf;  
}