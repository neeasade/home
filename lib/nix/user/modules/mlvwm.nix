{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.xsession.windowManager.wchf;
  mlvwm = pkgs.callPackage ../../pkgs/mlvwm.nix {};
in
  {
    options = {
      xsession.windowManager.mlvwm = {
        enable = mkEnableOption "mlvwm";
        config.initFile = mkOption {
          type = types.lines;
          default = "";
        };
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ mlvwm ];
      xdg.configFile.mlvwmrc.text = cfg.config.initFile;
      xsession.windowManager.command = "${mlvwm}/bin/mlvwm -f $XDG_CONFIG_FILE/mlvwmrc";
    };
  }
