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
  dwm
  dmenu
  st
  tabbed

  # For emacs
  gnutls

  # Languages
  racket
  lua
  python3
  chicken
  go
  godef

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
  xkeysnail
  lsc
  raleigh-reloaded-gtk-theme
  wendy
  ircdiscord

  # From Emacs overlay
  emacsUnstable
]
