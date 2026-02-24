{ ... }:
{
  imports = [
    ../modules/base/default.nix
    ../modules/hardware/amd-laptop.nix
    ../modules/gaming/glf/default.nix
  ];

  networking.hostName = "amd-laptop";
}

