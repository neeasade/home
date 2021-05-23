{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.programs.wayfire;
in {
  options.programs.wayfire = {
    enable = mkEnableOption "Wayfire";

    config = mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = {};
    };

    xwayland = mkOption {
      type = types.bool;
      default = true;
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wayfire
      (mkIf cfg.xwayland pkgs.xwayland)
    ] ++ cfg.extraPackages;


    xdg.configFile."wayfire.ini".text =
      (concatStringsSep "\n"
        (mapAttrsToList
          (section: kv:
            "[${section}]\n" +
            (concatStringsSep "\n"
              (mapAttrsToList (k: v: "${k} = ${v}") kv)))
          cfg.config));

    systemd.user = {
      targets.wayfire-session = {
        Unit = {
          Description = "Wayfire session";
          Documentation = [ "man:systemd-special(7)" ];
          After = [ "graphical-session-pre.target" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [ "graphical-session-pre.target" ];
        };
      };
      # services.wayfire = {
      #   Unit = {
      #     Description = "Wayfire";
      #     After = [ "graphical-session-pre.target" ];
      #     BindsTo = [ "graphical-session.target" ];
      #     Wants = [ "graphical-session-pre.target" ];
      #   };

      #   Service = {
      #     Type = "simple";
      #     ExecStart = ''
      #       ${pkgs.dbus}/bin/dbus-run-session ${pkgs.wayfire}/bin/wayfire "$@"
      #     '';
      #     Restart = "on-failure";
      #     RestartSec = 1;
      #     TimeoutStopSec = 10;
      #   };
      # };
    };
  };
}
