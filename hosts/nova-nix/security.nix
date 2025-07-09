{ config, pkgs, self, ... }:
{
 services = {
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
  };
 
  security = {
    rtkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
    pam.services.swaylock = {
      text = "auth include login";
    };  

    pam = {
      u2f = {
        enable = true;
        control = "sufficient"; # This means the key is SUFFICIENT for auth.
        settings = {
          cue = true;             # Prints "Please touch the device."
          authFile = "/home/ayrton/.config/Yubico/u2f_keys"; # Path to your Yubikey key file};
          origin = "pam://ayrton-local-nix-auth";     
        };
      };
      services =  {
    # This enables U2F/Passkey authentication for the 'sudo' service
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        u2f.enable = true;
      };       
    };
  }; 

  services.udev.packages = [ pkgs.libu2f-host ];    
}
