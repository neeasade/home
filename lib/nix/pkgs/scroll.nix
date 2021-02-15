{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "scroll";
  version = "unstable";
  src = builtins.fetchGit {
    url = "git://git.suckless.org/scroll";
    rev = "dda4e05544271c78f6f97318f19ab9edbaf7ba19";
    ref = "master";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "scrollback program for st";
    homepage = "https://git.suckless.org/scroll/file/README.html";
    platforms = platforms.linux;
  };
}
