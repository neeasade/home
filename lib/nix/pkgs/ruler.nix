{ stdenv
, lib
, fetchurl
, libwm
, libxcb
, xcbutilwm
, flex
, bison }:

stdenv.mkDerivation rec {
  name = "xruler-0.1.0";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/tudurom/ruler/archive/v${version}.tar.gz";
    sha256 = "5355e19530bb158b504cca6ba18cc402585e9bdb488e01a2ee76492bc70923c7";
  };

  patches = [ ../patches/ruler/001-fix_invalid_pointer_error.patch ];

  buildInputs = [ libxcb libwm xcbutilwm ];
  nativeBuildInputs = [ flex bison ];
  makeFlags = [ "LEX=flex" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Window rule daemon";
    homepage = "https://github.com/tudurom/ruler";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
