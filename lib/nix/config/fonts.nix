# Fontconfig

{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = false;
    fonts = [
      pkgs.go-font pkgs.ibm-plex pkgs.lmodern pkgs.lmmath

      # Fonts that aren't in nixpkgs
      pkgs.verily-serif-mono pkgs.charter pkgs.scientifica
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Verily Serif Mono" ];
        sansSerif = [ "IBM Plex Sans Condensed" ];
        serif     = [ "Charter" ];
      };
    };
  };
}
