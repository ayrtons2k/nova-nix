{ config, pkgs, self, ... }:
{
  services = {
  
    gnome.gnome-keyring.enable = true;
  
    openssh.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };  
}
