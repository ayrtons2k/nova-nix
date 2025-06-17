{ pkgs, ... }:

let
  myTerminal = "alacritty";
  myUser = "ayrton";
in
{
  home.packages = with pkgs; [
    i3status-rust
    brightnessctl
  ];

  # The main Sway module configuration
  programs.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = myTerminal;

      bars = [
        {
          command = "${pkgs.i3status-rust}/bin/i3status-rust -c /home/${myUser}/.config/i3status-rust/config.toml";
        }
      ];

      gaps = {
        inner = 10;
        outer = 5;
      };
    };

    # extraConfig is where we adapt our i3 config for Sway
    extraConfig = ''
      set $mod Mod4
      font pango:JetBrains Mono 10

      # --- KEYBINDINGS ADAPTED FOR SWAY ---
      bindsym $mod+Return exec ${myTerminal}
      bindsym $mod+Shift+q kill
      # Use wofi instead of rofi
      bindsym $mod+d exec wofi --show drun
      # Use swaylock instead of i3lock
      bindsym $mod+Shift+l exec swaylock -f -c 000000
      
      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart
      # Use swaynag instead of i3-nagbar
      bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit Sway?' -B 'Yes, exit Sway' 'swaymsg exit'

      # Use grim+slurp instead of flameshot
      bindsym Print exec grim -g "$(slurp)" - | wl-copy

      # Multimedia keys are unchanged
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

      # --- STARTUP APPS ---
      exec --no-startup-id nm-applet
      exec --no-startup-id blueman-applet
      exec --no-startup-id kdeconnect-indicator

      # --- WALLPAPER ---
      # This is the Sway-native way to set the wallpaper, replacing feh.
      # 'output *' applies to all connected monitors.
      output * bg ${../../wallpapers/i3wm-nova-nix.png} fill

      # Workspace bindings (unchanged from i3)
      bindsym $mod+1 workspace 1
      bindsym $mod+Shift+1 move container to workspace 1
      bindsym $mod+2 workspace 2
      bindsym $mod+Shift+2 move container to workspace 2
      bindsym $mod+3 workspace 3
      bindsym $mod+Shift+3 move container to workspace 3
      bindsym $mod+4 workspace 4
      bindsym $mod+Shift+4 move container to workspace 4
      bindsym $mod+5 workspace 5
      bindsym $mod+Shift+5 move container to workspace 5

      # Window rules (unchanged from i3)
      assign [class="^firefox$"] → 2
      assign [class="^code$"] → 3
      for_window [class="Pavucontrol"] floating enable
      for_window [class="blueman-manager"] floating enable
      for_window [title="alsamixer"] floating enable
    '';
  };

  # Keep the i3status config, as swaybar is compatible with it
  home.file.".config/i3status-rust/config.toml".source = ../config/i3status-rust.toml;
}