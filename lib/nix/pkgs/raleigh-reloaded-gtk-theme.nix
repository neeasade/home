{ stdenv, lib }:

stdenv.mkDerivation {
  name = "raleigh-reloaded-git";
  version = "git";

  src = builtins.fetchGit {
    url = "https://github.com/vlastavesely/raleigh-reloaded";
    rev = "041bc368a988506fe70a017edaef26d3feba582b";
    ref = "master";
  };

  preConfigure = ''
    sed -i "s|PREFIX=/usr|PREFIX=$out|" Makefile
  '';
  # installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A conservative GTK-3.20 theme aiming to revive the Raleigh theme";
    homepage = "https://github.com/vlastavesely/raleigh-reloaded";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
