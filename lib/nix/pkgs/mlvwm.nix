{ stdenv, fetchgit, gccmakedep
, imake, libX11, libXpm, libXext
}:

stdenv.mkDerivation rec {
  pname = "mlvwm";
  version = "unstable";
  src = fetchgit {
    url = "https://github.com/morgant/mlvwm";
    sha256 = "0zf4dakid912bj4fi0xx7frwc7jdahd4rzkdnmhk886z0ssf2hja";
    rev = "24578885f22084d9bc83b6950862fe10cc32c287";
    branchName = "master";
  };

  buildInputs = [
    libX11
    libXpm
    libXext
  ];

  nativeBuildInputs = [
    imake
    gccmakedep
  ];

  buildPhase = ''
    for i in man sample_rc mlvwm; do
        cd $i && xmkmf  -DMlvwmBinDir=$out/bin -DMlvwmLibDir=$out/lib && cd ..
    done

    xmkmf -DMlvwmBinDir=$out/bin -DMlvwmLibDir=$out/lib
    make
  '';

  installPhase = ''
    PREFIX=$out make install
    mkdir -p $out/share/man/man1
    cp ./man/mlvwm.man $out/share/man/man1/mlvwm.1
  '';
}
