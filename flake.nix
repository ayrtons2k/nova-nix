{
  description = "Ayrton's NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
    };    
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sddm-sugar-candy-nix, ... }@inputs: 
   let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnfreePredicate = (_: true);
    };
  in
  {
    nixosConfigurations.nova-nix = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        sddm-sugar-candy-nix.nixosModules.default
        ./hosts/nova-nix/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true; # Share nixpkgs with the system
          home-manager.useUserPackages = true; # Install user packages to /home/ayrton/.nix-profile
          home-manager.users.ayrton = import ./users/ayrton/home.nix;
          home-manager.backupFileExtension = "backup"; 
          home-manager.extraSpecialArgs = {
            unstable = import nixpkgs-unstable {
              system = pkgs.${system};
              config.allowUnfree = true;
              config.allowUnfreePredicate = (_: true);
            };
          };
        }
      ];
    };
  };
}