{ pkgs, ... }:
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
    quickshell
    usbutils
    vim
    wget
    yazi
  ];

  programs.git.enable = true;
}

