{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "verily-serif-mono";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/chrissimpkins/codeface/raw/master/fonts"
      + "/verily-serif-mono/VerilySerifMono.otf";
    sha256 = "91fb8818e0ee711795bb361da9cda167b26add54fec58d0069659c0fc29fc848";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp ${src} $out/share/fonts/opentype/VerilySerifMono.otf
  '';

  meta = with lib; {
    description = "https://www.fontsquirrel.com/fonts/Verily-Serif-Mono";
    homepage = "Modification of Bitstream Vera Sans Mono";
    platforms = platforms.linux;
  };
}
