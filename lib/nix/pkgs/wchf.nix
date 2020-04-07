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
    rev = "1ccc15d8e42345db401dd64f6e4f7bc8762ed902";
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
