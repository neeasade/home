{ stdenv, lib, hunspell, hunspellDicts }:

stdenv.mkDerivation rec {
  pname = "words";
  version = "latest";

  nativeBuildInputs = [
    hunspell
    hunspellDicts.en-gb-ise
  ];

  src = "${hunspellDicts.en-gb-ise}";

  sourceRoot = ".";
  buildPhase = ''
    unmunch ${hunspellDicts.en-gb-ise}/share/hunspell/en_GB.{dic,aff} |sort >words
  '';

  installPhase = ''
    mkdir -p $out/share/dict
    cp ./words $out/share/dict
  '';
}
