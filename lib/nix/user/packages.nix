{ pkgs, ... }:

with pkgs; [
  # General tools
  git
  mpv
  transmission
  ffmpeg
  wget
  curl
  file
  gnumake
  gcc
  socat
  gnupg
  doas
  hunspell
  hunspellDicts.en_GB-ise
  shellcheck

  # Xorg
  xdotool
  zathura
  slock
  pinentry-gnome
  xclip
  farbfeld
  xorg.xprop
  xorg.xrandr
  sxhkd
  bgs
  lemonbar-xft
  wmutils-core
  meh
  dmenu
  st
#  emacs

  # For emacs
  gnutls

  # Languages
  racket
  python3
  go

  # Latex
  (texlive.combine { inherit (texlive)
    scheme-minimal
    collection-latex
    collection-binextra
    collection-latexextra
    collection-pictures
    collection-latexrecommended
    collection-formatsextra
    collection-langenglish
    collection-mathscience
  ;})

  # Custom packages
  xscreenshot
  crud
  sprop
  wchf
  xmenu
  xruler
  lsc
  raleigh-reloaded-gtk-theme
  ircdiscord
  emacs27
]
