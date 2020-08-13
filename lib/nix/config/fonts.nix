# Fontconfig

{ config, pkgs, ... }:

{
  fonts = {
    # Noto fonts is a better package than the fonts included in the default list
    enableDefaultFonts = false;

    fonts = with pkgs; [
      go-font
      ibm-plex
      lmodern
      lmmath

      # Fonts that aren't in nixpkgs
      verily-serif-mono
      charter
      scientifica
      openmoji

      # Covers almost every language in the world!
      noto-fonts
      noto-fonts-cjk
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "IBM Plex Mono" ];
        sansSerif = [ "IBM Plex Sans Condensed" ];
        serif     = [ "Charter" ];
        emoji     = [ "OpenMoji" ];
      };
    };
  };
}
