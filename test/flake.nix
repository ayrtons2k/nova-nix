# test.nix
{
  # This imports your entire flake.nix from the current directory
  # The `.` is a shorthand for `flake:.`
  inputs.self.url = "path:."; 

  outputs = { self, ... }: {
    nixosConfigurations.test-build = self.nixosConfigurations.nova-nix.extendModules {
      # This adds our new, temporary module to the list that gets evaluated.
      modules = [
        {
          # This is the option you want to test!
          services.xserver.desktopManager.gnome.enable = false;
        }
      ];
    };
  };
}