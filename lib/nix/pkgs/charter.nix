{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "charter";
  version = "latest";

  src = fetchurl {
    name = "charter.zip";
    url = "https://practicaltypography.com/fonts/Charter%20200512.zip";
    sha256 = "18yk4qnzm4bn1y4cn0g2cddfiif6s6f6zmn477izcwcwidg63l9r";
  };

  nativeBuildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find "Charter/Charter/OpenType TT/" -name "*.ttf" -exec cp {} "$out/share/fonts/truetype/" \;
  '';

  meta = with stdenv.lib; {
    homepage = "https://practicaltypography.com/charter.html";
    description = "Charter was designed by Matthew Carter in 1987 as a body text font";
    platforms = platforms.linux;
  };
}
