# I think this dictionary itself needs some rewrite.  Hunspell reports
# zero corrections instead of no corrections for words already present
# which is very annoying as it means that I can't use it properly with
# ispell.
{ stdenv, lib, fetchgit }:

stdenv.mkDerivation rec {
  pname = "hunspellDicts-en-academic";
  version = "unstable";
  src = fetchgit {
    url = "https://github.com/emareg/acamedic";
    sha256 = "0vlxcp1r47ld875b7f343snwm7bvc902wd3bb50w40dj545sgbmc";
    rev = "2ee818950e4ae5fc974c0e405ea7dca08d8becfc";
    branchName = "master";
  };

  # See also: (man "5 hunspell")
  buildPhase = ''
    for i in src/academic/en_US_{chem,math,physics,unit,symbols}.dic \
                src/names/names_{people,scientists,misc,geo}.dic; do
      cat "$i"
      echo # Not ending files with a newline should be a crime against humanity!
    done |sed \
    -e 's/#.*//g' -e '/^[[:space:]]*$/d' |sort >en-Academic.dic.tmp
    wc -l <en-Academic.dic.tmp >en-Academic.dic.custom
    cat en-Academic.dic.tmp >>en-Academic.dic.custom
  '';

  installPhase = ''
    runHook preInstall
    install -dm755 $out/share/hunspell
    install -m644 en-Academic.dic.custom "$out/share/hunspell/en-Academic.dic"
    install -m644 en-Academic.aff "$out/share/hunspell/"
    install -dm755 $out/share/myspell/dicts
    ln -s $out/share/hunspell/en-Academic.dic $out/share/myspell/dicts
    ln -s $out/share/hunspell/en-Academic.aff $out/share/myspell/dicts
    runHook postInstall
  '';
}
