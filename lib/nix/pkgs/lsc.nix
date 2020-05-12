{ stdenv, libX11 }:

stdenv.mkDerivation rec {
  pname = "lsc";
  version = "unstable";
  src = builtins.fetchGit {
    url = "https://git.sr.ht/~viz/lsc";
    rev = "6c7aa5f0b3b898d66b55411beff4e6db02cbb9d4";
    ref = "master";
  };

  buildInputs = [ libX11 ];

  installFlags = [ "PREFIX:=$(out)" ];

  meta = with stdenv.lib; {
    description = "print children of a X parent window";
    homepage = "https://git.sr.ht/~viz/lsc";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
