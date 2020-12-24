{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.programs.kdeconnect;
in
  {
    options.programs.kdeconnect = {
      enable = mkEnableOption "Enable KDE Connect";
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.kdeconnect ];
    };

    nixosConfig = mkIf cfg.enable {
      networking.firewall = rec {
        allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };
  }
