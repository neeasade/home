{ lib, pkgs, config, ... }:

with lib; let
  ruler = pkgs.callPackage ../../pkgs/ruler.nix {
    libwm = pkgs.callPackage ../../pkgs/libwm.nix {};
  };
  cfg = config.services.ruler;

  # Shamelessly stolen from hm's sxhkd module
in
  {
    options.services.ruler = {
      enable = mkEnableOption "Ruler daemon";

      rules = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
        description = "An attributon set that assigns rule to command";
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = "Additional configuration";
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ ruler ];

      xdg.configFile."ruler/rulerrc".text = concatStringsSep "\n"
        ((mapAttrsToList (r: c: "${r}\n    ${c}") cfg.rules)
         ++ [ cfg.extraConfig ]);

      systemd.user.services.ruler = {
        Unit = {
          Description = "X Window Ruler daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service.ExecStart = "${ruler}/bin/ruler";

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  }
