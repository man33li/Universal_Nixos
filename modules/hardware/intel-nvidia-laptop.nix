{ config, ... }:
{
  imports = [ ./common-laptop.nix ];

  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.kernelModules = [ "kvm-intel" ];
}

