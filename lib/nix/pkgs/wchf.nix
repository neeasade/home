{ stdenv
, libX11
, libxcb
, xcbutilkeysyms
, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "wchf-git";
  version = "git";

  src = builtins.fetchGit {
    url = "https://github.com/vizs/wchf";
    rev = "35eb3e3ff91e9e6d27491f92f380112d1cc9edab";
    ref = "master";
  };

  buildInputs = [ libX11 libxcb xcbutilkeysyms xcbutilwm ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "personal fork of windowchef";
    homepage = "https://github.com/vizs/wchf";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
