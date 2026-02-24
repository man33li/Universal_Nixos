{ lib, ... }:
{
  imports = [
    ./fanatec.nix
    ./new-lg4ff.nix
    ./gaming.nix
  ];

  glf.gaming.enable = lib.mkDefault true;
}

