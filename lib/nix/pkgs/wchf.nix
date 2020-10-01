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
    rev = "64fb469479167561fadf61569eff80fd4df1cc7a";
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
