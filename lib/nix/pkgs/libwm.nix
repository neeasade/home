{ stdenv, libxcb }:

stdenv.mkDerivation rec {
  name = "libwm-git";
  version = "git";

  src = builtins.fetchGit {
    url = "https://github.com/wmutils/libwm";
    rev = "c92ee4ce0527c1983e6fef40fc43a43fde832f24";
    ref = "master";
  };

  buildInputs = [ libxcb ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A small library for X windows manipulation";
    homepage = "https://github.com/wmutils/libwm";
    platforms = platforms.linux;
  };
}
