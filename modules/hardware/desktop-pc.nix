{ lib, config, ... }:
let
  cfg = config.universal.desktop;
  isEfi = builtins.pathExists "/sys/firmware/efi";
in
{
  options.universal.desktop.gpuVendor = lib.mkOption {
    type = lib.types.enum [ "nvidia" "amd" "intel" ];
    default = "nvidia";
    description = "Desktop GPU vendor profile.";
  };

  config = lib.mkMerge [
    {
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub.enable = true;
      boot.loader.grub.efiSupport = lib.mkDefault isEfi;
      boot.loader.grub.device = lib.mkDefault (if isEfi then "nodev" else "/dev/sda");
      boot.loader.grub.useOSProber = true;
      boot.loader.efi.canTouchEfiVariables = lib.mkForce isEfi;
    }

    (lib.mkIf (cfg.gpuVendor == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        nvidiaSettings = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    })

    (lib.mkIf (cfg.gpuVendor == "amd") {
      services.xserver.videoDrivers = [ "amdgpu" ];
      boot.initrd.kernelModules = [ "amdgpu" ];
    })

    (lib.mkIf (cfg.gpuVendor == "intel") {
      services.xserver.videoDrivers = [ "modesetting" ];
    })
  ];
}

