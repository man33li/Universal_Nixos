{ lib, config, pkgs, ... }:
let
  userCfg = config.universal.user;
in
{
  options.universal = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "gamer";
        description = "Primary local user account name.";
      };

      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Universal User";
        description = "Display name of the primary local user.";
      };

      hashedPassword = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional hashed password for the primary user.";
      };
    };

    system = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "System timezone.";
      };

      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "System locale.";
      };
    };
  };

  config = {
    time.timeZone = config.universal.system.timeZone;
    i18n.defaultLocale = config.universal.system.locale;
    environment.shells = [ pkgs.nushell ];

    users.mutableUsers = lib.mkDefault true;
    users.groups.games = {};

    users.users.${userCfg.name} = {
      isNormalUser = true;
      description = userCfg.fullName;
      shell = pkgs.nushell;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "games" ];
    } // lib.optionalAttrs (userCfg.hashedPassword == null) {
      initialPassword = "changeme";
    } // lib.optionalAttrs (userCfg.hashedPassword != null) {
      hashedPassword = userCfg.hashedPassword;
    };
  };
}

