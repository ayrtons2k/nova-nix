{ config, pkgs, self, ... }:
{
  services = {
    xserver.videoDrivers = [ "nvidia" ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;  # Use proprietary drivers
      nvidiaSettings = true;
      #package = config.boot.kernelPackages.nvidiaPackages.beta;
      #package = config.boot.kernelPackages.nvidiaPackages.latest;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      #package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        linuxPackages.nvidia_x11
        libGLU
        libGL
        cudatoolkit
        gperf
      ];
    };
  }; #hardware
  programs = {
    hyprland = {
      enable = true; # Set to true if you want to use Hyprland instead of Sway
    };
  }; #programs


}
