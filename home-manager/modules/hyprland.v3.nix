# hyprland.nix (Minimal Stable Version)
{ pkgs, ... }:

let
  # --- THEME CONFIGURATION ---
  primaryColor = "fabd2f";
  colors = {
    primary = "rgb(${primaryColor})";
    background = "rgb(282828)";
    foreground = "rgb(ebdbb2)";
    black = "rgb(3c3836)";
  };

  # --- FONT ---
  # IMPORTANT: Since 'nerdfonts' is removed from packages,
  # you MUST have a Nerd Font installed by other means.
  # Make sure this name exactly matches the font you have installed.
  font = "JetBrainsMono Nerd Font";

in
{
  # --- PACKAGES ---
  # nerdfonts has been removed as requested.
  home.packages = with pkgs; [
    waybar  wofi  wlogout  hyprpicker  hyprlock 
    grim  slurp  wl-clipboard  jq 
    brightnessctl  pavucontrol
  ];

  # --- HYPRLAND CONFIGURATION ---
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "DP-2, 5120x1440@120, 0x0, 1";
      "exec-once" = [
        "hyprpaper -c ~/.config/hypr/hyprpaper.conf"
        "waybar" # This should now execute correctly
        "nm-applet"
        "blueman-applet"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "${colors.primary}";
        "col.inactive_border" = "${colors.black}";
        layout = "dwindle";
      };

      # --- MINIMAL DECORATION FOR STABILITY ---
      # We have removed blur and shadows to guarantee the config loads.
      # We will add them back later.
      decoration = {
        rounding = 15;
      };

      animations.enabled = true; # Keep animations simple for now

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad.natural_scroll = true;
      };

      bind = [
        "SUPER, RETURN, exec, alacritty"
        "SUPER, D, exec, wofi --show drun"
        "SUPER SHIFT, Q, killactive,"
        "SUPER SHIFT, E, exec, wlogout"
        "SUPER SHIFT, L, exec, hyprlock"
        "SUPER, V, togglefloating,"
        "SUPER, F, fullscreen,"
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
      ];

      windowrulev2 = [
        "float, class:^(Pavucontrol)$"
        "float, class:^(blueman-manager)$"
      ];
    };
  };

 programs.waybar = {
    enable = true;
    style = builtins.readFile ../waybar/style.css;
    settings = [{
      layer = "top";
      position = "top";
      mod = "dock";
      exclusive = true;
      passtrough = false;
      gtk-layer-shell = true;
      height = 0;
      modules-left = [
        "hyprland/workspaces"
        "custom/divider"
        "custom/weather"
        "custom/divider"
        "cpu"
        "custom/divider"
        "memory"
      ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "tray"
        "network"
        "custom/divider"
        "backlight"
        "custom/divider"
        "pulseaudio"
        "custom/divider"
        "battery"
        "custom/divider"
        "clock"
      ];
      "hyprland/window" = { format = "{}"; };
      "wlr/workspaces" = {
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        all-outputs = true;
        on-click = "activate";
      };
      battery = { format = "󰁹 {}%"; };
      cpu = {
        interval = 10;
        format = "󰻠 {}%";
        max-length = 10;
        on-click = "";
      };
      memory = {
        interval = 30;
        format = "  {}%";
        format-alt = " {used:0.1f}G";
        max-length = 10;
      };
      backlight = {
        format = "󰖨 {}";
        device = "acpi_video0";
      };
      "custom/weather" = {
        tooltip = true;
        format = "{}";
        restart-interval = 300;
        exec = "/home/roastbeefer/.cargo/bin/weather";
      };
      tray = {
        icon-size = 13;
        tooltip = false;
        spacing = 10;
      };
      network = {
        format = "󰖩 {essid}";
        format-disconnected = "󰖪 disconnected";
      };
      clock = {
        format = " {:%I:%M %p   %m/%d} ";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        tooltip = false;
        format-muted = " Muted";
        on-click = "pamixer -t";
        on-scroll-up = "pamixer -i 5";
        on-scroll-down = "pamixer -d 5";
        scroll-step = 5;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
      };
      "pulseaudio#microphone" = {
        format = "{format_source}";
        tooltip = false;
        format-source = " {volume}%";
        format-source-muted = " Muted";
        on-click = "pamixer --default-source -t";
        on-scroll-up = "pamixer --default-source -i 5";
        on-scroll-down = "pamixer --default-source -d 5";
        scroll-step = 5;
      };
      "custom/divider" = {
        format = " | ";
        interval = "once";
        tooltip = false;
      };
      "custom/endright" = {
        format = "_";
        interval = "once";
        tooltip = false;
      };
    }];
  };
  # --- WLOGOUT & OTHER CONFIG FILES ---
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock"; action = "hyprlock"; }
      { label = "logout"; action = "hyprctl dispatch exit"; }
      { label = "suspend"; action = "systemctl suspend"; }
      { label = "reboot"; action = "systemctl reboot"; }
      { label = "shutdown"; action = "systemctl shutdown now"; }
    ];
  };
  home.file.".config/hypr/hyprpaper.conf".source = ./../config/hyprpaper.conf;
  home.file.".config/wlogout/style.css".text = ''
    * { background-image: none; font-family: ${font}; }
    window { background-color: rgba(24, 25, 38, 0.8); }
    button { color: ${colors.foreground}; background-color: ${colors.background}; border: 2px solid ${colors.black}; background-repeat: no-repeat; background-position: center; background-size: 25%; }
    button:focus, button:active, button:hover { background-color: ${colors.primary}; color: ${colors.background}; border-color: ${colors.primary}; }
    #lock { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/lock.png"); }
    #logout { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/logout.png"); }
    #suspend { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/suspend.png"); }
    #reboot { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/reboot.png"); }
    #shutdown { background-image: image(url: "${pkgs.wlogout}/share/wlogout/icons/shutdown.png"); }
  '';
}