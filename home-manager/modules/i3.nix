{ pkgs, ... }:

let
  alacritty = "alacritty";
in
{
  home.packages = with pkgs; [
    i3status-rust
    brightnessctl
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      # This block is now corrected according to the wiki.
      # It is 'bars' (a list) and uses 'statusCommand'.
      bars = [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rust -c ~/.config/i3status-rust/config.toml";
        }
      ];

      modifier = "Mod4";
      terminal = alacritty;
      # font = "pango:JetBrains Mono 10";

      keybindings = {
        # # Mod + Key bindings
        # "$mod+Return" = "exec ${alacritty}";
        # "$mod+Shift+q" = "kill";
        # "$mod+d" = "exec rofi -show drun";
        # "$mod+Shift+l" = "exec i3lock -c 000000";
        # "$mod+Shift+c" = "reload";
        # "$mod+Shift+r" = "restart";
        # "$mod+Shift+e" = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'";

        # # Standalone Keybindings (Function/Multimedia Keys)
        # "Print" = "exec flameshot gui";
        # "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        # "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        # "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        # "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        # "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
      # workspaces = {
      #   "1" = { key = "1"; };
      #   "2" = { key = "2"; };
      #   "3" = { key = "3"; };
      #   "4" = { key = "4"; };
      #   "5" = { key = "5"; };
      # };

      gaps = {
        inner = 10;
        outer = 5;
      };

      startup = [
        {
          command = "feh --bg-scale ${../../wallpapers/i3wm-nova-nix.png}";
          always = true;
          notification = false;
        }
        { command = "nm-applet"; always = true; notification = false; }
        { command = "blueman-applet"; always = true; notification = false; }
        #{ command = "kdeconnect-indicator"; always = true; notification = false; }
      ];

      window = {
        # assigns = {
        #   "2" = [{ class = "firefox"; }];
        #   "3" = [{ class = "code"; }];
        # };
        # floating.criteria = [
        #   { class = "Pavucontrol"; }
        #   { class = "blueman-manager"; }
        #   { title = "alsamixer"; }
        # ]; 
      };
    };

  # Add the workspace definitions to extraConfig.
      extraConfig = ''
      # We explicitly define the $mod variable ourselves.
      set $mod Mod4

      # Set the font for window titles
      font pango:JetBrains Mono 10

      # --- KEYBINDINGS ARE NOW DEFINED HERE ---
      # Your keybindings, now written in raw i3 config syntax.
      # App launching and window management
      bindsym $mod+Return exec ${alacritty}
      bindsym $mod+Shift+q kill
      bindsym $mod+d exec rofi -show drun
      bindsym $mod+Shift+l exec i3lock -c 000000
      
      # i3 commands
      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart
      bindsym $mod+Shift+e exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'

      # Multimedia and function keys (no $mod needed)
      bindsym Print exec flameshot gui
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

      # Startup applications
      exec --no-startup-id nm-applet
      exec --no-startup-id blueman-applet

      # Workspace bindings
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

      # Assign applications to specific workspaces
      assign [class="^firefox$"] → 2
      assign [class="^code$"] → 3

      # Make certain windows floating
      for_window [class="Pavucontrol"] floating enable
      for_window [class="blueman-manager"] floating enable
      for_window [title="alsamixer"] floating enable
    '';
  };

  # This file is still used by the statusCommand above.
  home.file.".config/i3status-rust/config.toml".source = ../config/i3status-rust.toml;
}