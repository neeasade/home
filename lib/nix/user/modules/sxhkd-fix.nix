{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.services.sxhkd;
in
  {
    config = mkIf cfg.enable {
      systemd.user.services.sxhkd.Service = lib.mkForce {
        ExecStart = "${pkgs.sxhkd}/bin/sxhkd";
      };
    };
  }
