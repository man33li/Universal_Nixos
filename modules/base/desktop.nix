{ pkgs, config, ... }:
let
  user = config.universal.user.name;
in
{
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;

  hardware.graphics.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.niri}/bin/niri-session";
      user = user;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    TERMINAL = "ghostty";
    GTK_THEME = "Colloid-Dark";
  };

  environment.etc."hypr/hyprlock.conf".text = ''
    general {
      disable_loading_bar = true
      hide_cursor = false
    }

    background {
      monitor =
      color = rgba(16, 18, 24, 0.95)
    }

    input-field {
      monitor =
      size = 320, 56
      position = 0, -80
      valign = center
      halign = center
      outline_thickness = 2
      fade_on_empty = false
      placeholder_text = Password...
    }
  '';

  systemd.user.services.dunst = {
    description = "Dunst notification daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  systemd.user.services.quickshell = {
    description = "Quickshell panel service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.quickshell}/bin/qs";
      Restart = "on-failure";
      RestartSec = 2;
      Environment = [
        "QML2_IMPORT_PATH=${pkgs.quickshell}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
      ];
    };
  };
}
