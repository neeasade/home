{ pkgs, ... }:

with pkgs; [
  # General tools
  git
  transmission
  wget
  curl
  file
  socat
  doas

  # Encyrption stuff
  #
  # TODO: Look into using masterpassword and a proper password
  # manager?
  gnupg
  pinentry-gnome

  # Dictionary
  hunspell
  hunspellDicts.en_GB-ise

  # Xorg related tools
  xdotool
  xclip
  xorg.xprop
  xorg.xrandr
  wmutils-core

  # Multimedia
  # Yes, IK that I have two image viewers and PDF readers (if you
  # count pdf-tools, I have three lol)
  ffmpeg
  mpv
  zathura
  sxiv
  meh
  okular

  # Communication
  signal-desktop

  slock
  farbfeld
  bgs
  lemonbar-xft
  dmenu                         # TODO: Look into using rofi or emacs (lol)?
  st

  # Languages and language related tools
  racket
  python3
  go
  shellcheck
  gnumake
  gcc

  gnutls                        # For emacs

  # Latex. I mainly write chemistry and maths
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

    simplekv                    # For chemfig
  ;})

  # Custom packages
  xscreenshot
  crud
  xmenu
  raleigh-reloaded-gtk-theme
  ircdiscord
  wendy
  # These are for tabbed which I don't use anymore
  # sprop
  # lsc
]
