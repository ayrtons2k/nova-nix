{
  description = "Ayrton's NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.nova-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true; # Share nixpkgs with the system
          home-manager.useUserPackages = true; # Install user packages to /home/ayrton/.nix-profile
          home-manager.users.ayrton = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs = {
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
              config.allowUnfreePredicate = (_: true);
            };
            # customPkgs = import nixpkgs {
            #   system = "x86_64-linux";
            #   config.allowUnfree = true;
            #   config.allowUnfreePredicate = (_: true);
            # };
          };
        }
      ];
    };
  };
}