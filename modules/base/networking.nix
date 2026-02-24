{ ... }:
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.openssh.enable = true;
}

