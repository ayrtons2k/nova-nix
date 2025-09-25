# ./modules/nixos/common-vm.nix
{
  # --- Bootloader Fix (The Key Discovery) ---
  # Enable systemd-boot to ensure the kernel and initrd are built.
  boot.loader.systemd-boot.enable = true;
  # Prevent it from trying to write to physical EFI hardware.
  boot.loader.efi.canTouchEfiVariables = false;

  # --- QEMU Guest Integration ---
  # Enable the guest agent for better host integration, using the
  # correct option for NixOS 25.05.
  services.qemuGuest.enable = true;
}