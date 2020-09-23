{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.services.xsession.windowManager.wchf;
  wchf = pkgs.callPackage ../../pkgs/wchf.nix {};
in
  {
    options = {
      services.xsession.windowManager.wchf = {
        enable = mkEnableOption "wchf";

        # configPath = mkOption {
        #   default = "";
        #   type = types.path;
        # };
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ wchf ];
      xsession.windowManager.command = "${wchf}/bin/wchf";
    };
  }
