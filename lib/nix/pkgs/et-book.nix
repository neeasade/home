{ stdenv, lib, fetchgit }:

stdenv.mkDerivation {
  pname = "et-book-fonts";
  version = "latest";

  src = fetchgit {
    url = "https://github.com/edwardtufte/et-book";
    sha256 = "1bhpk1fbp8jdhzc5j8y5v3bpnzy2sz3dpgjgzclb0dnm51hqqrpn";
    rev = "24d3a3bbfc880095d3df2b9e9d60d05819138e89";
    branchName  = "gh-pages";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/{open,true}type
    find $src/et-book -name '*.ttf' -exec cp {} "$out/share/fonts/truetype/" \;
    # find $src/et-book -name '*.otf' -exec cp {} "$out/share/fonts/opentype/" \;
  '';
}
