# ./hosts/web-vm/default.nix
{ config, pkgs, flake-nixpkgs, ... }: # Or your working function signature
{
  imports = [
    ../../modules/nixos/common-vm.nix
    "${flake-nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" # Or your working import
  ];

  networking.hostName = "web-vm";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    group = "nixos";
  };

  users.groups.nixos = {}; 

  # --- The rest of your configuration is perfect ---                   
  services.openssh.enable = true;
  services.nginx = {
    enable = true;how to f 
    virtualHosts."localhost".root = pkgs.runCommand "index.html" {} ''
      mkdir -p $out
      echo "<h1>SUCCESS! The VM is running!</h1>" > $out/index.html
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 22 ];

  virtualisation.qemu.options = [
    "-m 2048"
    "-smp 2"
    "-netdev user,id=n1,hostfwd=tcp::8080-:80,hostfwd=tcp::2222-:22"
    "-device virtio-net-pci,netdev=n1"
  ];

  system.stateVersion = "25.05";
}