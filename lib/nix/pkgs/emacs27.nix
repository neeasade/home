{ stdenv, fetchurl
, pkgconfig, autoconf, automake, texinfo
, ncurses, libXpm, jansson, gmp, gettext
, cairo, libtiff, harfbuzz, libpng, libjpeg, librsvg, libungif
, gtk3-x11, gnutls, libxml2, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "emacs27";
  version = "27.1-rc1";
  src = fetchurl {
    url = "https://github.com/emacs-mirror/emacs/archive/emacs-${version}.tar.gz";
    sha256 = "04p1xg0qzx3676i2cfanivjwf5q3ccr9vyal3bwmy2q8s10hwccf";
  };

  buildInputs = [
    ncurses libXpm jansson gmp gettext
    cairo libtiff harfbuzz libpng libjpeg librsvg libungif
    gtk3-x11 gnutls libxml2 webkitgtk
  ];
  nativeBuildInputs = [
    pkgconfig
    autoconf
    automake
    texinfo
  ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    ./autogen.sh
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
    "--with-xwidgets"
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
