{ ... }:
{
  imports = [
    ../modules/base/default.nix
    ../modules/hardware/intel-nvidia-laptop.nix
    ../modules/gaming/glf/default.nix
  ];

  networking.hostName = "razer-blade-pro-2014";
}

