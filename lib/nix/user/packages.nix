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
  exiftool
  zip unzip

  # Encyrption stuff
  #
  # TODO: Look into using masterpassword and a proper password
  # manager?
  gnupg
  pinentry-gnome

  # Spelling
  hunspell
  hunspellDicts.en-gb-ise
  hunspellDicts.en-academic
  # aspellDicts.ta
  # aspellDicts.en-science

  # Xorg related tools
  xdotool
  xclip
  xorg.xprop
  xorg.xrandr
  wmutils-core
  # WOOOO.  AFAICS, dragging stuff _from_ Emacs is not possible.
  xdragon


  # Multimedia
  # Yes, IK that I have two image viewers and PDF readers (if you
  # count pdf-tools, I have three lol)
  ffmpeg
  mpv
  zathura
  sxiv
  meh
  okular
  koreader
  gimp

  # With a couple of patches, this is so far the best paint
  # replacement.
  drawing

  # Communication
  session-desktop
  kdeconnect

  tor-browser-bundle-bin

  slock
  farbfeld
  bgs
  # lemonbar-xft
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
  go-sam
  # ircdiscord
  # wendy
  # These are for tabbed which I don't use anymore
  # sprop
  # lsc
]
