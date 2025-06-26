{ pkgs, config, inputs, options,... }:
let
  myTerminal = "alacritty";
  myUser = "ayrton";

  primaryColor = "fabd2f"; 

  colors = {
    primary = "rgb(${primaryColor})";
    background = "rgb(282828)";
    foreground = "rgb(ebdbb2)";
    black = "rgb(3c3836)";
    gray = "rgb(928374)";
    red = "rgb(fb4934)";
    green = "rgb(b8bb26)";
    blue = "rgb(83a598)";
  };
  #valid Scales that work for me
  scaleOneFourteen = "1.142857";
  ScaleOneTwentyFive = "1.25";
  scaleOne = "1.0";

  # Set the font for the entire system
  font = "JetBrainsMono Nerd Font";

  hyprland-bar-wrapper = pkgs.writeShellScriptBin "hyprland-bar-wrapper" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.sway}/bin/swaybar --status-command "${pkgs.i3status-rust}/bin/i3status-rs -c /home/${myUser}/.config/i3status-rust/config.toml"
  '';

  # --- SCRIPT WRAPPERS ---

  screenshot-wrapper = pkgs.writeShellScriptBin "screenshot-region" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  # ++ NEW ++ : Screenshot fullscreen
  screenshot_full = pkgs.writeShellScriptBin "screenshot-full" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  # ++ NEW ++ : Screenshot active window (requires jq)
  screenshot_win = pkgs.writeShellScriptBin "screenshot-win" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.grim}/bin/grim -g "$(${pkgs.hyprland}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  # ++ NEW ++ : Toggle Waybar
  toggle_bar = pkgs.writeShellScriptBin "toggle-bar" ''
    #!${pkgs.stdenv.shell}
    pkill -SIGUSR1 waybar
  '';

  #Script to apply monitor settings after a delay to help. Fix to scaling not being applied correctly 
  setup-monitor-script = pkgs.writeShellScriptBin "setup-monitor" ''
    #!${pkgs.stdenv.shell}
    # Wait 2 seconds for the system to settle before applying monitor config
    sleep 2
    ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-2, 5120x1440@120, 0x0, 1.0"
  '';


  # --- ++ NEW ++ : Keybinding Cheat Sheet Generation ---
  keybind-hints = ''
    HYPRLAND KEYBINDINGS (MOD = SUPER)

    -- APPS & CORE --
 
      ❖ + RETURN                Launch Terminal
      ❖ + H                     Launch htop
      ❖ + R                     App Launcher 
      SHIFT + Q                 Close active window
      ❖ + V                     Toggle floating
      ❖ + F                     Toggle fullscreen

    -- FOCUS & MOVEMENT --
      ❖ + Arrows                Move focus
      ❖ + SHIFT + Arrows        Swap/Move window
      ❖ + CTRL + Arrows         Resize window

    -- LAYOUT & GROUPS --
      ❖ + J                     Toggle layout split (v/h)
      ❖ + G                     Toggle window grouping
      ❖ + Tab                   Cycle focus in a group

    -- UTILITIES --
      ❖ + X                     Show Power Menu
      ❖ + K                     Show this cheat sheet
      ❖ + B                     Toggle Waybar visibility
      ❖ + P                     Color Picker (copy hex)
      Print Screen              Screenshot region
      ❖ + Print                 Screenshot fullscreen
      ❖ + SHIFT + Print         Screenshot active window
      ❖ + CTRL + V              Screenshot active window


    -- EYE CANDY --
      ❖ + CTRL + B              Toggle background blur

    -- WORKSPACES --
      ❖ + 1-0                   Switch to workspace
      ❖ + SHIFT + 1-0           Move window to workspace
      ❖ + Mouse Wheel           Cycle workspaces

    -- SESSION & SYSTEM --
      ❖ + SHIFT + X             Power menu
      ❖ + SHIFT + L             Lock screen (hyprlock)
      ❖ + SHIFT + C             Reload Hyprland config
      ❖ + SHIFT + E             Exit Hyprland session
      ❖ + SHIFT + S             Suspend System
      (Media Keys)               Volume / Brightness


  '';

  keybind-script = pkgs.writeShellScriptBin "keybinds" ''
    #!''${pkgs.stdenv.shell}
    echo -e "${keybind-hints}" | ${pkgs.wofi}/bin/wofi --show dmenu -i --style ~/.config/wofi/style.css --width=600 --height=500
  '';  
in
{
   # Make all our scripts and new packages available
  home.packages = with pkgs; [
    # ... your other packages
    wlogout # The graphical logout menu from the screenshot
    wleave
    hyprpicker
    # Utilities
    grim 
    slurp 
    wl-clipboard 
    brightnessctl 
        # Your existing packages
    # All our script wrappers
    screenshot-wrapper
    screenshot_full
    screenshot_win
    toggle_bar
    keybind-script
    hyprcursor
    setup-monitor-script    
    jq
  ];

  # hyprcursor = {
  #   enable = true;
  #   theme = "rose-pine-hyprcursor";
  # };

  # cursor.package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
  # cursor.name = "BreezX-RosePine-Linux";

  programs.waybar = {
    enable = true;
    # Tell Waybar where to find its stylesheet
    style = ./../config/waybar.css;
    # Define the bar's layout and modules
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        modules-left = [ "custom/launcher" "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "network" "cpu" "memory" ];
        modules-right = [ "tray" "pulseaudio" "clock" "custom/power"];

        # Module-specific settings
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "0" = "0";
            "default" = "";
          };
        };


        "custom/launcher" = 
          { 
            format = "     "; 
            tooltip = false; 
            on-click = "wofi --show drun"; 
          };

        "custom/power" = { 
          format = "    "; 
          tooltip = false; 
          on-click = "wlogout"; 
        };

        
        "clock" = {
          format = "   {:%a %d %b %H:%M} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = " {icon} {volume}% ";
          format-muted = "  Muted ";
          format-icons = {
            default = [ "  " "   " ];
          };
        };

        "network" = {
          format-wifi = "   {ipaddr} ";
          format-ethernet = " 󰈀 {ipaddr} ";
          format-disconnected = " Disconnected ";
        };
        
        "cpu" = {
          format = "   {usage}% ";
        };

        "memory" = {
          format = "  {}% ";
        };
      };
    };
  };


    xdg.configFile."wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 2px solid #bd93f9; /* Dracula Purple */
        background-color: #282a36; /* Dracula Background */
        border-radius: 5px;
    }

    #input {
        margin: 5px;
        border: none;
        color: #f8f8f2; /* Dracula Foreground */
        background-color: #44475a; /* Dracula Current Line */
        border-radius: 3px;
    }

    #inner-box {
        margin: 5px;
        border: none;
        background-color: #282a36; /* Dracula Background */
    }

    #outer-box {
        margin: 5px;
        border: none;
        background-color: #282a36; /* Dracula Background */
    }

    #scroll {
        margin: 0px;
        border: none;
    }

    #text {
        margin: 5px;
        border: none;
        color: #f8f8f2; /* Dracula Foreground */
    }

    #entry:selected {
        background-color: #44475a; /* Dracula Current Line */
        outline: none;
    }
  '';

    # wlogout configuration (example layout)
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "${pkgs.hyprlock}/bin/hyprlock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          keybind = "s";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          keybind = "h";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          keybind = "p";
        }
      ];
      style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        background-image: none;
        transition: 0.1s;
      }
      window {
        background-color: rgba(30, 30, 46, 0.8); /* Catppuccin Base */
      }
      button {
        color: #cdd6f4; /* Catppuccin Text */
        background-color: rgba(49, 50, 68, 0.8); /* Catppuccin Surface0 */
        border: 2px solid #313244; /* Catppuccin Surface0 darker for border */
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 10px;
        margin: 10px;
        padding: 10px;
      }
      button:focus, button:active, button:hover {
        background-color: #45475a; /* Catppuccin Surface1 */
        border: 2px solid #585b70; /* Catppuccin Surface2 */
      }

      #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); } 
      #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }     

      
      '';
    };


    # xdg.configFile."wlogout/layout".text = builtins.toJSON config.programs.wlogout.layout;
    # xdg.configFile."wlogout/style.css".text = config.programs.wlogout.style;

  

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
        /* 
      Fractional Scale	Decimal Value for hyprland.conf	Resulting Logical Resolution between 1 and 2 for a 5120px monitor
          16/15	1.066667	4800 x 1350
          10/9	1.111111	4608 x 1296
           8/7  1.142857	4480 x 1260
           5/4  1.25	    4096 x 1152
           4/3  1.333333	3840 x 1080
          10/7	1.428571	3584 x 1008
           8/5  1.6	3200 x 900
           5/3  1.666667	3072 x 864
           2/1  2.0	2560 x 720

        */

      "exec-once" = [
        "hyprpaper -c ~/.config/hypr/hyprpaper.conf" 
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "nm-applet"
        "blueman-applet"
        "kdeconnect-indicator"
        "waybar"
        "exec-once = wl-paste --watch cliphist store"
        #"setup-monitor"
        #"dbus-update-activation-environment --systemd --all"
         "/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh" 
      ];



      # --- INPUT AND GENERAL ---
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad.natural_scroll = true;
        #  cursor = {
        #   inactive_timeout = 0; # A timeout of 0 disables hiding the cursor
        # };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(78BCF0)";
        "col.inactive_border" = "rgb(504945)";
        #layout = "master";
        layout = "dwindle";
        #cursor_inactive_timeout = 0;
      };

      # --- DECORATION AND ANIMATION ---
      decoration = {
        rounding = 10;
        blur = {
            enabled = true;          
            size = 8;                 # How strong the blur is. Higher is more blurry.
            passes = 3;               # More passes can look smoother but use more GPU. 2-4 is a good range.
            new_optimizations = true; # Use newer, more efficient blur algorithms.
            ignore_opacity = true;    # Recommended to ensure blur works correctly with transparent windows.
            xray = false;             # Set to `true` to see through all windows behind the active one. Can be disorienting.
          };      
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 0, 9, default"
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
        # -- Apps & Core Window Management --
        "${mainMod}, RETURN, exec, ${myTerminal}"
        "${mainMod}, H, exec, ${myTerminal} -e htop"
        "${mainMod}, E, exec, dolphin" # <-- ADD THIS LINE
        "${mainMod} SHIFT, Q, killactive,"
        "${mainMod}, R, exec, wofi --show drun"
        "${mainMod}, V, togglefloating,"
        "${mainMod}, F, fullscreen,"

        # -- Focus & Tiled Window Movement --
        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"
        "${mainMod} SHIFT, left, movewindow, l"
        "${mainMod} SHIFT, right, movewindow, r"
        "${mainMod} SHIFT, up, movewindow, u"
        "${mainMod} SHIFT, down, movewindow, d"

        # -- Tiled Window Resizing --
        "${mainMod} CONTROL, left, resizeactive, -20 0"
        "${mainMod} CONTROL, right, resizeactive, 20 0"
        "${mainMod} CONTROL, up, resizeactive, 0 -20"
        "${mainMod} CONTROL, down, resizeactive, 0 20"

        # -- Layout & Grouping --
        #"${mainMod}, J, dispatch, togglesplit"          # <-- FIX: Added 'dispatch' for internal command
        "${mainMod}, G, togglegroup,"
        "${mainMod}, tab, changegroupactive, f"

        # -- Utilities --
        "${mainMod}, K, exec, keybinds"
        "${mainMod}, B, exec, toggle-bar"
        "${mainMod}, P, exec, hyprpicker -a"
        ", Print, exec, screenshot-region"
        "${mainMod}, Print, exec, screenshot-full"
        "${mainMod} SHIFT, Print, exec, screenshot-win"
        "${mainMod} CTRL, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # -- Eye Candy --
        "${mainMod} CTRL, B, exec, bash -c 'hyprctl keyword decoration:blur:enabled toggle'" # <-- FIX: Wrapped command in bash -c

        # -- Workspace Management --
        # (Your workspace bindings are all correct)
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
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"

        # -- System, Session & Media --
        "${mainMod} SHIFT, X, exec, wlogout"
        "${mainMod} SHIFT, L, exec, hyprlock"
        "${mainMod} SHIFT, C, exec, hyprctl reload"
        "${mainMod} SHIFT, E, exit,"
        "${mainMod} SHIFT, S, exec, systemctl suspend"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # --- WINDOW RULES ---
      windowrulev2 = [
        "opacity 0.85 0.70, class:(.*)"
        "workspace 2, class:^(firefox)$"
        "workspace 3, class:^(Code)$" # Note: VSCode class is often capitalized
        "float, class:^(Pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(alsamixer)$"
        "float, class:^(thunar)$" # 
        "float, class:^(dolphin)$" # <-- ADD THIS LINE
      ];
      monitor = "DP-2, 5120x1440@120, 0x0, 1.25";
    };
  };
home.file.".config/hypr/hyprpaper.conf" = {
    # The `text` attribute allows us to use Nix string interpolation.
    text = ''
      preload = ${../../wallpapers/hyprlnd-nova-nix.png}
      splash = false
      wallpaper = DP-2, ${../../wallpapers/hyprlnd-nova-nix.png}
    '';
  };}