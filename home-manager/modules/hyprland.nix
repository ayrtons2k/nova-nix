{ pkgs, options,... }:
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

  # Set the font for the entire system
  font = "JetBrainsMono Nerd Font";

 power-menu-script = pkgs.writeShellScriptBin "power-menu" ''
    #!${pkgs.stdenv.shell}

    # Define the options with Nerd Font icons
    options=
      " Lock
        Logout
        Suspend
        Reboot
        Shutdown"

    # Show the menu with wofi, using the explicit Nix store path for wofi
    # This makes the script much more reliable.
    selected=$(${pkgs.lib.getExe pkgs.wofi} --show dmenu -p "Power Menu" --style ~/.config/wofi/powermenu.css --width=250 --height=300 <<< "$options")

    # Execute the selected action using explicit paths for all commands
    case "$selected" in
        " Lock")
            ${pkgs.lib.getExe pkgs.hyprlock}
            ;;
        " Logout")
            ${pkgs.lib.getExe pkgs.hyprland} dispatch exit
            ;;
        " Suspend")
            ${pkgs.lib.getExe pkgs.systemd}/bin/systemctl suspend
            ;;
        " Reboot")
            ${pkgs.lib.getExe pkgs.systemd}/bin/systemctl reboot
            ;;
        " Shutdown")
            ${pkgs.lib.getExe pkgs.systemd}/bin/systemctl shutdown now
            ;;
    esac
  '';


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


  # --- ++ NEW ++ : Keybinding Cheat Sheet Generation ---
  keybind-hints = ''
     # --- Keybinding Cheat Sheet Generation ---
  # This has been updated to reflect all current bindings.
    HYPRLAND KEYBINDINGS (MOD = SUPER)

    -- APPS & CORE --
      SUPER + RETURN                Launch Terminal
      SUPER + H                     Launch htop
      SUPER + D                     App Launcher (wofi)
      SHIFT + Q                     Close active window
      SUPER + V                     Toggle floating
      SUPER + F                     Toggle fullscreen

    -- FOCUS & MOVEMENT --
      SUPER + Arrows                Move focus
      SUPER + SHIFT + Arrows        Swap/Move window
      SUPER + CTRL + Arrows         Resize window

    -- LAYOUT & GROUPS --
      SUPER + J                     Toggle layout split (v/h)
      SUPER + G                     Toggle window grouping
      SUPER + Tab                   Cycle focus in a group

    -- UTILITIES --
      SUPER + X                     Show Power Menu
      SUPER + K                     Show this cheat sheet
      SUPER + B                     Toggle Waybar visibility
      SUPER + P                     Color Picker (copy hex)
      Print Screen                  Screenshot region
      SUPER + Print                 Screenshot fullscreen
      SUPER + SHIFT + Print         Screenshot active window

    -- EYE CANDY --
      SUPER + CTRL + B              Toggle background blur

    -- WORKSPACES --
      SUPER + 1-0                   Switch to workspace
      SUPER + SHIFT + 1-0           Move window to workspace
      SUPER + Mouse Wheel           Cycle workspaces

    -- SESSION & SYSTEM --
      SUPER + SHIFT + X             Power menu
      SUPER + SHIFT + L             Lock screen (hyprlock)
      SUPER + SHIFT + C             Reload Hyprland config
      SUPER + SHIFT + E             Exit Hyprland session
      SUPER + SHIFT + S             Suspend System
      (Media Keys)                  Volume / Brightness


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
    power-menu-script 
    wlogout # The graphical logout menu from the screenshot
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
    # New dependencies
    jq
  ];

 
  programs.waybar = {
    enable = true;
    # Tell Waybar where to find its stylesheet
    style = ./../config/waybar.css;
    # Define the bar's layout and modules
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "custom/launcher" "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "pulseaudio" "network" "cpu" "memory" "custom/power"];

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
          format-wifi = "   {essid} ";
          format-ethernet = " 󰈀 {ifname} ";
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


   programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock"; action = "hyprlock"; }
      { label = "logout"; action = "hyprctl dispatch exit"; }
      { label = "suspend"; action = "systemctl suspend"; }
      { label = "reboot"; action = "systemctl reboot"; }
      { label = "shutdown"; action = "systemctl shutdown now"; }
    ];
    style = ''
      * {
          background-image: none;
          font-family: ${font};
      }
      window {
          background-color: rgba(24, 25, 38, 0.8);
      }
      button {
          color: ${colors.foreground};
          background-color: ${colors.background};
          border-style: solid;
          border-width: 2px;
          border-color: ${colors.black};
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;k
      }
      button:focus, button:active, button:hover {
          background-color: ${colors.primary};
          color: ${colors.background};
          border-color: ${colors.primary};
      }
      #lock { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/lock.png"); }
      #logout { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/logout.png"); }
      #suspend { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/suspend.png"); }
      #reboot { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/reboot.png"); }
      #shutdown { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/shutdown.png"); }
    '';
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
        "waybar"
      ];

      # --- INPUT AND GENERAL ---
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(78BCF0)";
        "col.inactive_border" = "rgb(504945)";
        layout = "dwindle";
      };

      # --- DECORATION AND ANIMATION ---
      decoration = {
        rounding = 10;
        blur = {
            enabled = true;          # This is the most important line!
            size = 8;                # How strong the blur is. Higher is more blurry.
            passes = 3;              # More passes can look smoother but use more GPU. 2-4 is a good range.
            new_optimizations = true; # Use newer, more efficient blur algorithms.
            ignore_opacity = true;   # Recommended to ensure blur works correctly with transparent windows.
            xray = false;            # Set to `true` to see through all windows behind the active one. Can be disorienting.
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
        # -- Apps & Core Window Management --
        "${mainMod}, RETURN, exec, ${myTerminal}"
        "${mainMod}, H, exec, ${myTerminal} -e htop"
        "${mainMod}, E, exec, dolphin" # <-- ADD THIS LINE
        "${mainMod} SHIFT, Q, killactive,"
        "${mainMod}, D, exec, wofi --show drun"
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

        # -- Eye Candy --
        "${mainMod} CONTROL, B, exec, bash -c 'hyprctl keyword decoration:blur:enabled toggle'" # <-- FIX: Wrapped command in bash -c

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
        "${mainMod} SHIFT, X, exec, power-menu"
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
        "opacity 0.92 0.85, class:(.*)"
        "workspace 2, class:^(firefox)$"
        "workspace 3, class:^(Code)$" # Note: VSCode class is often capitalized
        "float, class:^(Pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(alsamixer)$"
        "float, class:^(thunar)$" # 
        "float, class:^(dolphin)$" # <-- ADD THIS LINE
      ];
    };
  };
  home.file.".config/hypr/hyprpaper.conf".source = ./../config/hyprpaper.conf;  
}