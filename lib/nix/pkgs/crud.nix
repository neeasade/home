{ stdenv, fetchurl, libX11, pkgs, pkgconfig }:

stdenv.mkDerivation rec {
  name = "crud-0.1.1";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/ix/crud/archive/${version}.tar.gz";
    sha256 = "7b669cda9ab016232b9c6ba907a267c8ae9c62f41e888871475670eb2f4033b8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with pkgs; [ libX11 xorg.libXcursor xorg.xorgproto xorg.libXext ];

  patches = [ ../patches/crud/001-add_geometry_flag.patch ];

  preConfigure = ''
    sed -i "s|PREFIX ?= /usr/local|PREFIX ?= $out|" Makefile
  '';

  meta = with stdenv.lib; {
    description = "Prints the geometry of a selected regin in X11";
    homepage = "https://github.com/ix/crud";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
