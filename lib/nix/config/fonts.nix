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
      # charter
      scientifica
      openmoji

      # Covers almost every language
      noto-fonts
      noto-fonts-cjk
      lohit-fonts.tamil
      lohit-fonts.tamil-classical
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "Luxi Mono" "IBM Plex Mono" ];
        sansSerif = [ "IBM Plex Sans Condensed" ];
        serif     = [ "Charter" ];
        emoji     = [ "OpenMoji" ];
      };
    };
  };
}
