{ stdenv, lib, fetchurl, pkg-config, meson, ninja
, wayfire, cairo, wf-config, glibmm, wlroots
, wayland-protocols, wayland, libxkbcommon, libudev }:

stdenv.mkDerivation rec {
  name = "wayfire-plugins-extra";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/${name}/releases/download/v${version}/${name}-${version}.tar.xz";
    sha256 = "1sr195n2ch31j182bf3nkch17dk1dyx6vx51z3w9ql6mrr0b1p01";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayfire
    cairo
    wf-config
    glibmm
    wlroots
    wayland-protocols
    wayland
    libxkbcommon
    libudev
  ];
}
