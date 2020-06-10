{ stdenv
, libX11
, libxcb
, xcbutil
, xcbutilkeysyms
, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "wchf-git";
  version = "git";

  src = builtins.fetchGit {
    url = "https://github.com/vizs/wchf";
    rev = "2d56077b3cd641c11b4ae8a8242a993a09a3a43c";
    ref = "master";
  };

  buildInputs = [ libX11 libxcb xcbutil xcbutilkeysyms xcbutilwm ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "personal fork of windowchef";
    homepage = "https://github.com/vizs/wchf";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
