
{ config, pkgs, self, ... }:
{    
  system.nixos.label = "V4";
    # Bootloader
  nixpkgs.config.allowUnfree = true;    
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;

      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_12;
    kernelParams = [
      "nvidia_drm.modeset=1"
    ];    
  };
  systemd.user.services.cliphist-daemon = {
    description = "Clipboard History Daemon (cliphist)";
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    script = ''
      ${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store
    '';
    serviceConfig = {
      Restart = "on-failure";
    };
  }; 
  programs = {
    ssh.startAgent = true;
  };
}
