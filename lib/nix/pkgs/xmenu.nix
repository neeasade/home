{ stdenv
, fontconfig
, freetype
, libxcb
, xcbutilxrm
, xcbutilrenderutil }:

stdenv.mkDerivation rec {
  name = "xmenu-git";
  version = "git";

  src = builtins.fetchGit {
    url = "git://git.z3bra.org/xmenu.git";
    rev = "cfe26f791c3ecbe16beab4e44248f38823417164";
    ref = "master";
  };

  buildInputs = [
    fontconfig freetype
    libxcb xcbutilxrm xcbutilrenderutil
  ];
  installFlags = [ "PREFIX=$(out)" ];

  patches = [
    ../patches/xmenu/001-change_configh.patch
  ];

  meta = with stdenv.lib; {
    description = "Drop-down menu for X11";
    homepage = "git://git.z3bra.org/xmenu";
    platforms = platforms.linux;
  };
}
