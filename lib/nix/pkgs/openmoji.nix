{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "openmoji";
  version = "12.3.0";
  src = fetchurl {
    url = "https://github.com/hfg-gmuend/${pname}/releases"
          + "/download/${version}/${pname}-font.zip";
    sha256 = "0s7ngrrablfq8ixzbjkq66b6w8hds5nmhwm7684adwq0yr4a1xbx";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";
  installPhase = ''
ls
    mkdir -p $out/share/fonts/truetype
    cp OpenMoji-Color.ttf $out/share/fonts/truetype/
  '';

  meta = with stdenv.lib; {
    description = "Opensource emojis for everyone";
    homepage = "https://openmoji.org";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
  };
}
