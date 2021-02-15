{ stdenv, lib, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "charter";
  version = "latest";

  src = fetchurl {
    name = "charter.zip";
    url = "https://practicaltypography.com/fonts/Charter%20210112.zip";
    sha256 = "1j8iv2dl695zrabs2knb7jsky8mjis29a2ddpna4by8mlvqrf0ml";
  };

  nativeBuildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/fonts/{open,true}type
    find Charter\ */TTF*/Charter/ -name "*.ttf" -exec cp {} "$out/share/fonts/truetype/" \;
    #find Charter\ */OTF*/Charter/ -name "*.otf" -exec cp {} "$out/share/fonts/opentype/" \;
  '';

  meta = with lib; {
    homepage = "https://practicaltypography.com/charter.html";
    description = "Charter was designed by Matthew Carter in 1987 as a body text font";
    platforms = platforms.linux;
  };
}
