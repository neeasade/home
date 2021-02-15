{ stdenv, lib, libX11 }:

stdenv.mkDerivation rec {
  name = "sprop-git";
  version = "git";

  src = builtins.fetchGit {
    url = "git://git.suckless.org/sprop";
    rev = "c0e990ecaea56a7d5aadb708ea28a99dba8fd926";
    ref = "master";
  };

  buildInputs = [ libX11 ];
  patches = [ ../patches/sprop/001-optional_atom_type.patch ];

  makeFlags = [ "CC:=$(CC)" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Set X Property";
    homepage = https://tools.suckless.org/x/sprop;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
