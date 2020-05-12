{ stdenv, fetchurl, pkgconfig
, ncurses, libXpm, jansson, gmp, gettext
, cairo, libtiff, harfbuzz, libpng, libjpeg
, gtk3-x11, gnutls
}:

stdenv.mkDerivation rec {
  pname = "emacs27";
  version = "27.0.91";
  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/emacs/pretest/emacs-${version}.tar.xz";
    sha256 = "1aj52fymw4iq9n5sahpb3wncm0cvshwmjr3833mirj6yhp9kv0cn";
  };

  buildInputs = [
    ncurses libXpm jansson gmp gettext
    cairo libtiff harfbuzz libpng libjpeg
    gtk3-x11 gnutls
  ];
  nativeBuildInputs = [ pkgconfig ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale
    for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
  '';

  configureFlags = [
    "--with-x"
    "--with-x-toolkit=gtk3"
    "--with-gnutls"
    "--with-json"
    "--with-cairo"
    "--with-modules"
    "--with-harfbuzz"
    "--without-sound"
    "--without-dbus"
    "--without-gsettings"
    "--without-libsystemd"
    "--without-gif"
  ];

  installTargets = [ "tags" "install" ];

  postInstall = let
    sitestart = "${builtins.fetchurl
      "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/applications/editors/emacs/site-start.el"}";
  in ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${sitestart} $out/share/emacs/site-lisp/site-start.el
    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el
    rm -fr $out/{var,share/emacs/${version}/site-lisp}
  '';

  meta = with stdenv.lib; {
    description = "GNU Emacs";
    homepage = "https://www.gnu.org/software/emacs";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
