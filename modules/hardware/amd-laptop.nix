{ ... }:
{
  imports = [ ./common-laptop.nix ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "amd_pstate=active" ];
}

