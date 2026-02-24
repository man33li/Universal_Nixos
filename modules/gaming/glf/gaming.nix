{ config, options, pkgs, lib, pkgs-unstable, ... }:

let
  pkgOrNull = path: lib.attrByPath path null pkgs-unstable;
  lutrisPkg = pkgOrNull [ "lutris" ];
  mesaDemosPkg = pkgOrNull [ "mesa-demos" ];
  vulkanToolsPkg = pkgOrNull [ "vulkan-tools" ];
  heroicPkg = pkgOrNull [ "heroic" ];
  joystickwakePkg = pkgOrNull [ "joystickwake" ];
  hidTmff2Pkg = pkgOrNull [ "linuxKernel" "packages" "linux_6_18" "hid-tmff2" ];
  mangohudPkg = pkgOrNull [ "mangohud" ];
  goverlayPkg = pkgOrNull [ "goverlay" ];
  vkbasaltPkg = pkgOrNull [ "vkbasalt" ];
  oversteerPkg = pkgOrNull [ "oversteer" ];
  umuLauncherPkg = pkgOrNull [ "umu-launcher" ];
  wineStagingPkg = pkgOrNull [ "wineWow64Packages" "staging" ];
  winetricksPkg = pkgOrNull [ "winetricks" ];
  piperPkg = pkgOrNull [ "piper" ];
  inputRemapperPkg = pkgOrNull [ "input-remapper" ];
  faugusLauncherPkg = pkgOrNull [ "faugus-launcher" ];
  protonGePkg = pkgOrNull [ "proton-ge-bin" ];

  gamingPackages = lib.filter (pkg: pkg != null) [
    (if lutrisPkg != null then lutrisPkg.override {
      extraLibraries = p: [ p.libadwaita p.gtk4 ];
    } else null)
    mesaDemosPkg
    vulkanToolsPkg
    heroicPkg
    joystickwakePkg
    hidTmff2Pkg
    mangohudPkg
    goverlayPkg
    vkbasaltPkg
    oversteerPkg
    umuLauncherPkg
    wineStagingPkg
    winetricksPkg
    piperPkg
    inputRemapperPkg
    faugusLauncherPkg
  ];
in
{
  options.glf.mangohud = lib.mkOption {
    type = lib.types.anything;
    default = {};
    internal = true;
    visible = false;
    description = "Deprecated: MangoHud is now managed by GOverlay.";
  };

  options.glf.gaming.enable = lib.mkOption {
    description = "Enable GLF gaming optimizations, controllers, and programs";
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf config.glf.gaming.enable (lib.mkMerge [
    {
      environment.systemPackages = gamingPackages;
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };

      services.udev.extraRules = ''
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';

      services.udev.packages = lib.optional (oversteerPkg != null) oversteerPkg;

      hardware.fanatec.enable = lib.mkDefault true;
      hardware.new-lg4ff_vff.enable = lib.mkDefault true;
      hardware.steam-hardware.enable = lib.mkDefault true;
      services.ratbagd.enable = lib.mkDefault true;

      programs.gamemode.enable = true;
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            TZ = ":/etc/localtime";
            OBS_VKCAPTURE = true;
          };
        };
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraCompatPackages = lib.optional (protonGePkg != null) protonGePkg;
      };
    }

    (lib.mkIf (lib.hasAttrByPath [ "services" "hardware" "openrgb" "enable" ] options) {
      services.hardware.openrgb.enable = true;
    })

    (lib.mkIf (lib.hasAttrByPath [ "hardware" "xone" "enable" ] options) {
      hardware.xone.enable = true;
    })

    (lib.mkIf (lib.hasAttrByPath [ "hardware" "xpadneo" "enable" ] options) {
      hardware.xpadneo.enable = true;
    })

    (lib.mkIf (lib.hasAttrByPath [ "hardware" "opentabletdriver" "enable" ] options) {
      hardware.opentabletdriver.enable = true;
    })

    (lib.mkIf (vkbasaltPkg != null) {
      system.activationScripts.vkbasalt-compat = ''
        mkdir -p /usr/share/vulkan/implicit_layer.d
        ln -sf /run/current-system/sw/share/vulkan/implicit_layer.d/vkBasalt.json /usr/share/vulkan/implicit_layer.d/vkBasalt.json
        mkdir -p /usr/lib
        if [ -f "${vkbasaltPkg}/lib/libvkbasalt.so" ]; then
          ln -sf "${vkbasaltPkg}/lib/libvkbasalt.so" /usr/lib/libvkbasalt.so
        fi
      '';
    })
  ]);
}

