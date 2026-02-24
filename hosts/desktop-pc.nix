{ ... }:
{
  imports = [
    ../modules/base/default.nix
    ../modules/hardware/desktop-pc.nix
    ../modules/gaming/glf/default.nix
  ];

  networking.hostName = "desktop-pc";
  universal.desktop.gpuVendor = "nvidia";
}

