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
    rev = "12f22e8c356e98c8c3e746dab7cbc1a232f076b6";
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
