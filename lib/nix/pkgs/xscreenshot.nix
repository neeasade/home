{ stdenv, libX11 }:

stdenv.mkDerivation rec {
  name = "xscreenshot-git";
  version = "git";

  src = builtins.fetchGit {
    url = "git://git.2f30.org/xscreenshot.git";
    rev = "f6c6ca5f7a38cf8e3f415ead5d53169b46d95e29";
    ref = "master";
  };

  buildInputs = [ libX11 ];

  patches = [ ../patches/xscreenshot/001-add_geometry_flag.patch ];

  makeFlags = [ "CC:=$(CC)" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "suckless screen capture tool";
    homepage = https://git.2f30.org/xscreenshot;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
