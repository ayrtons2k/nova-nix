# modules/gnome.nix
{ config, pkgs, ... }:

{
  # This module configures GNOME services needed for a minimal (non-GNOME) desktop.
  
  # 1. Enable Dconf for GTK application settings.
  # This is crucial for applications that store their preferences here.
  programs.dconf.enable = true;

  # 2. Enable the GNOME Keyring daemon.
  # This provides a secure place to store secrets, passwords, and SSH keys.
  services.gnome.gnome-keyring.enable = true;

  # 3. Explicitly disable the GNOME Desktop.
  # This is the key fix. It satisfies a check in a dependency pulled in by
  # Stylix's GTK module, preventing the build from crashing.
  services.desktopManager.gnome.enable = false;

  # 4. Integrate the keyring with the login manager (PAM).
  # This ensures your keyring is unlocked automatically when you log in.
  security.pam.services.sddm.enableGnomeKeyring = true;
}