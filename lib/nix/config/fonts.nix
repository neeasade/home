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
      et-book-fonts
      # charter
      # scientifica

      # Covers almost every language
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      # lohit-fonts.tamil
      # lohit-fonts.tamil-classical
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [
          "Luxi Mono"
          "IBM Plex Mono"
          "Noto Sans Tamil"
          "Noto Sans Tamil Supplement"
        ];
        sansSerif = [
          "IBM Plex Sans Condensed"
          "Noto Sans Tamil"
          "Noto Sans Tamil Supplement"
        ];
        serif = [
          "Charter"
          "Noto Serif Tamil"
          "Noto Sans Tamil Supplement"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
