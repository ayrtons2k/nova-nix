{ pkgs, ... }:

let
  myTerminal = "alacritty";
  myUser = "ayrton";

  # --- 1. THEME CONFIGURATION ---
  # Change the primary color here to theme your entire desktop!
  # Your yellow from before:
  primaryColor = "fabd2f"; 
  # The purple from the screenshot:
  # primaryColor = "6C4C75";
# We'll build a Gruvbox-style palette around your primary color
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

#Wofi power menu
# in your let block, alongside your other scripts

 power-menu-script = pkgs.writeShellScriptBin "power-menu" ''
    #!${pkgs.stdenv.shell}

    # Define the options with Nerd Font icons
    options=" Lock\n Logout\n Suspend\n Reboot\n Shutdown"

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
      SHIFT + Q             Close active window
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
      Print Screen          Screenshot region
      SUPER + Print         Screenshot fullscreen
      SUPER + SHIFT + Print Screenshot active window

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
      (Media Keys)          Volume / Brightness


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
    wl-clipboard jq
    brightnessctl 
        # Your existing packages
    # All our script wrappers
    screenshot-wrapper
    screenshot_full
    screenshot_win
    toggle_bar
    keybind-script
    # New dependencies
    wofi
    jq
  ];

  # # Waybar Configuration (Looks good!)
  # programs.waybar = {
  #   enable = true;
  #   style = ./../config/waybar.css;
  #   settings = {
  #     # ... your waybar settings are unchanged ...
  #   };
  # };

  # The Home Manager module for Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = let
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
      input = { /* ...unchanged... */ };
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "${colors.primary}";
        "col.inactive_border" = "${colors.black}";
        layout = "dwindle";
      };
      
            # Decorations (blur, rounding, shadows)
      decoration = {
        rounding = 15;
        blur.enabled = true;
        # drop_shadow = true;
        #shadow_range = 12;
        #shadow_render_power = 2;
        #"col.shadow" = "rgba(00000044)";
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
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      # --- KEYBINDINGS ---
       bind = [
        # -- Apps & Core Window Management --
        "${mainMod}, RETURN, exec, ${myTerminal}"
        "${mainMod}, H, exec, ${myTerminal} -e htop"
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
      windowrulev2 = [ /* ...unchanged... */ ];
    };
  };
 # --- 4. WAYBAR (THE TOP BAR) ---
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 45;
        spacing = 5;
        "modules-left" = [ "custom/launcher" "hyprland/window" ];
        "modules-center" = [ "hyprland/workspaces" ];
        "modules-right" = [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray" "custom/power" ];

        # Module definitions
        "custom/launcher" = { format = " "; tooltip = false; on-click = "wofi --show drun"; };
        "hyprland/window" = { max-length = 50; };
        "hyprland/workspaces" = { format = "{icon}"; format-icons = { "default" = ""; "active" = ""; }; };
        "pulseaudio" = { format = "{icon} {volume}%"; format-icons = { "default" = ["" "" ""]; }; on-click = "pavucontrol"; };
        "network" = { format-wifi = "  {essid}"; format-ethernet = "󰈀"; format-disconnected = "󰖪"; };
        "cpu" = { format = "  {usage}%"; };
        "memory" = { format = " {used:0.1f}G"; };
        #"battery" = { format = "{icon} {capacity}%"; format-icons = ["", "", "", "", ""]; };
        "clock" = { format = "{:%H:%M}"; };
        "custom/power" = { format = ""; tooltip = false; on-click = "wlogout"; };
      };
    };
    # The crucial CSS to get the puffy, rounded look
    style = ''
      * {
        font-family: ${font}, FontAwesome;
        font-size: 14px;
        border: none;
        border-radius: 20px;
      }
      window#waybar {
        background: transparent;
        color: ${colors.foreground};
      }
      #workspaces, #clock, #battery, #pulseaudio, #network, #cpu, #memory, #custom-launcher, #custom-power, #tray, #window {
        background: ${colors.black};
        padding: 4px 14px;
        margin: 5px 3px;
        color: ${colors.foreground};
      }
      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
      }
      #workspaces button.active {
        background: ${colors.primary};
        color: ${colors.background};
      }
    '';
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
          background-size: 25%;
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

  # Add hyprpaper config and wofi style file
  home.file.".config/hypr/hyprpaper.conf".source = ./../config/hyprpaper.conf;
  
  # ++ NEW ++ Wofi stylesheet for the keybinding helper
  home.file.".config/wofi/style.css".text = ''
    /* A basic wofi style that matches your theme */
    window {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
        background-color: #282828;
        color: #ebdbb2;
        border: 2px solid #fabd2f;
        border-radius: 10px;
    }
    #input {
        background-color: #504945;
        border: none;
        border-radius: 0;
        padding: 8px;
        margin: 8px;
    }
    #entry:selected {
        background-color: #fabd2f;
        color: #282828;
    }
  '';
  #Wofi power menu
  home.file.".config/wofi/powermenu.css".text = ''
    /* Power menu style, looks similar to the main style */
    window {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 16px;
        background-color: #282828;
        color: #ebdbb2;
        border: 2px solid #fabd2f;
        border-radius: 10px;
    }

    #input {
        visibility: hidden; /* We don't need to search */
    }
    
    #outer-box {
        padding: 20px;
    }

    #entry {
        padding: 8px;
        border-radius: 5px;
    }

    /* Make the selected item stand out, with a dangerous red color */
    #entry:selected {
        background-color: #fb4934; /* Gruvbox red */
        color: #282828;
    }
  '';




}