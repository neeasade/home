{ lib, pkgs, config, ... }:

with lib; let
  ruler = pkgs.callPackage ../../pkgs/ruler.nix {
    libwm = pkgs.callPackage ../../pkgs/libwm.nix {};
  };
  cfg = config.services.ruler;
in
  {
    options.services.ruler = {
      enable = mkEnableOption "Ruler daemon";

      rules = {
        name = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = {};
          description = "An attribution set that assigns window name to command";
        };

        class = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = {};
          description = "An attribution set that assigns window class to command";
        };

        instance = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = {};
          description = "An attribution set that assigns window instance to command";
        };

        type = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = {};
          description = "An attribution set that assigns window type to command";
        };

        role = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = {};
          description = "An attribution set that assigns window role to command";
        };
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
        ((mapAttrsToList (r: c: "name=\"${r}\"\n    ${c}") cfg.rules.name)
         ++ (mapAttrsToList (r: c: "class=\"${r}\"\n    ${c}") cfg.rules.class)
         ++ (mapAttrsToList (r: c: "instance=\"${r}\"\n    ${c}") cfg.rules.instance)
         ++ (mapAttrsToList (r: c: "type=\"${r}\"\n    ${c}") cfg.rules.type)
         ++ (mapAttrsToList (r: c: "role=\"${r}\"\n    ${c}") cfg.rules.role)
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
