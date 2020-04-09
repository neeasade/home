{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "charter";
  version = "latest";

  src = fetchurl {
    url = "https://practicaltypography.com/fonts/charter.zip";
    sha256 = "bcddb75c25406def3d461c6f161ce10f3b32433f5b2109fc0716782ff21285b7";
  };

  nativeBuildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find charter/ttf -name "*.ttf" -exec cp {} "$out/share/fonts/truetype/" \;
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
