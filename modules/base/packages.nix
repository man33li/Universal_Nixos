{ pkgs, pkgs-unstable, ... }:
let
  quickshellPkg = if pkgs ? quickshell then pkgs.quickshell else pkgs-unstable.quickshell;
in
{
  environment.systemPackages = with pkgs; [
    anyrun
    colloid-gtk-theme
    curl
    dunst
    ghostty
    git
    helix
    htop
    hyprlock
    lm_sensors
    niri
    pciutils
    quickshellPkg
    usbutils
    vim
    wget
    yazi
  ];

  programs.git.enable = true;
}

