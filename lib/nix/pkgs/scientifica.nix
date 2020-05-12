{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "scientifica";
  version = "2.1";
  src = fetchurl {
    url = "https://github.com/NerdyPepper/${pname}" 
      + "/releases/download/v${version}/${pname}-v${version}.tar";
    sha256 = "3159ce09e7850309c3c32a884870f77ed5fcb"
      + "01f7a2e6ebc9a84bba7cd7e5ab6";
  };

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp scientifica/{otb,bdf}/* $out/share/fonts/misc
  '';

  meta = with stdenv.lib; {
    description = "tall, condensed, bitmap font for geeks";
    homepage = "https://github.com/nerdypepper/scientifica";
    license = licenses.ofl;
    platforms = platforms.linux;
  };
}
