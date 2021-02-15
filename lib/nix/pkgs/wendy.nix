{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "wendy";
  version = "latest";
  src = builtins.fetchGit {
    url = "git://git.z3bra.org/wendy";
    rev = "a2cde2182b52311df842a36c13fddbc6e416df07";
    ref = "master";
  };

  installFlags = [ "PREFIX:=$(out)" "MANDIR:=$(out)/share/man" ];

  meta = with lib; {
    description = "inotify based event watcher";
    homepage = "http://z3bra.org/wendy/";
    platforms = platforms.linux;
  };
}
