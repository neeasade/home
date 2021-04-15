{ stdenv, lib, fetchurl, rustPlatform, nodePackages, cmake, pkg-config
, ffmpeg-full, fltk, openssl, x264, libva
, libdrm, libGL, libGLU, libX11, libXcomposite, libXcursor, libXext
, libXfixes, libXft, libXinerama, libXrandr, libXtst }:

rustPlatform.buildRustPackage rec {
  pname = "weylus";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/H-M-H/Weylus/archive/v${version}.tar.gz";
    sha256 = "1p4di6p6nnyd9f2a3i9q63j4065a2xabb2gk395b6x82y5vdywvk";
  };

  nativeBuildInputs = [
    nodePackages.typescript
    pkg-config
    cmake
  ];

  buildInputs = [
    cmake
    ffmpeg-full
    fltk
    openssl
    x264
    libva
    libdrm
    libGL
    libGLU
    libX11
    libXcomposite
    libXcursor
    libXext
    libXfixes
    libXft
    libXinerama
    libXrandr
    libXtst
  ];

  verifyCargoDeps = false;
  cargoSha256 = "1cshvqn8n00lnmzwarvflzf9l1431qh7g9vri5x8xyx6g2g9m6lw";

  prePatch = ''
    mkdir -p deps/dist/{include,lib}

    cp -r ${ffmpeg-full}/include/* deps/dist/include
    cp -r ${ffmpeg-full}/lib/* deps/dist/lib
    ls ${x264}/ # deps/dist/lib
  '';

  meta = with lib; {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    homepage = "https://github.com/H-M-H/Weylus";
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}


# { cmake, fetchFromGitHub, ffmpeg_4, fltk, lib, libGL, libGLU, libX11
# , libXcomposite, libXcursor, libXext, libXfixes, libXft, libXinerama, libXrandr
# , libXtst, nodePackages, openssl, pkg-config, rustPlatform, stdenv, x264 }:

# rustPlatform.buildRustPackage rec {
#   pname = "weylus";
#   version = "0.7.2";

#   src = fetchFromGitHub {
#     owner = "H-M-H";
#     repo = "Weylus";
#     rev = "v${version}";
#     sha256 = "03nd90h6ba9g6gpdvnznp3mlq6ml1f5rzdzyzv8bj2rvvgl0cs5n";
#   };

#   cargoSha256 = "0mh811i6b739kwrzn850iqdbswqrs8hw30mks5pcb9rjvx03balv";
#   verifyCargoDeps = false;

#   nativeBuildInputs = [ nodePackages.typescript pkg-config ];

#   buildInputs = [
#     cmake
#     ffmpeg_4
#     fltk
#     libGL
#     libGLU
#     libX11
#     libXcomposite
#     libXcursor
#     libXext
#     libXfixes
#     libXft
#     libXinerama
#     libXrandr
#     libXtst
#     openssl
#     x264
#   ];

#   prePatch = ''
#     mkdir -p deps/dist/{include,lib}

#     substituteInPlace build.rs \
#       --replace rustc-link-lib=static= rustc-link-lib=
#   '';

#   meta = with lib; {
#     description =
#       "Use your tablet as graphic tablet/touch screen on your computer";
#     homepage = "https://github.com/H-M-H/Weylus";
#     license = licenses.agpl3;
#     platforms = platforms.unix;
#   };
# }
