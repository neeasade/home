# The initial problem I had with the dictionary was because I
# generated the dictionary file incorrectly.  The first line in the
# dictionary file has to include an approximate number of entries so
# hunspell can create an efficient hashtable ahead-of-time.  However,
# there are some problems with the way words are strung together.
# For example, "methoxide" is being corrected to "meth-oxide" and/or
# "meth oxide" but both are incorrect, same with "dichloromethane."
# For that, I should take a look at modifying the .aff file.
# The other potential problem is that it is based off of the US SCOWL
# dictionary.  I prefer the British spelling.  But considering that I
# use en_GB-ise+en_Academic together, I _shouldn't_ have a problem but
# maybe there's a way to trivially ‘sed’ ize with ise, and er with re?
# The latter might be a problem though, and I'm not even sure if this
# is worth doing since _most_ words should be in the
# British dictionary.
#
# Ref.: (man "5 hunspell")
# Edit: (find-file-other-window "~/lib/repos/acamedic/en-Academic.aff")
#
# I will just put it here so I don't forget but the following words
# aren't included in the dictionary:
# physisorption chemisorbed physisorbed delocalized magnetisation nucleophile
# electrophile immiscible
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
