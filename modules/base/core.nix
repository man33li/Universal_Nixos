{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  boot.kernelParams = lib.mkDefault [ "quiet" "nowatchdog" ];

  time.hardwareClockInLocalTime = lib.mkDefault false;

  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.05";
}

