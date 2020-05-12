# From diamondburned (https://github.com/diamondburned)
{ stdenv, pkgs, fetchurl, autoPatchelfHook, lib, ... }:

let deps = with pkgs; [
  xlibs.libX11
  SDL SDL_image
  zlib
  libjpeg
  libpng_apng
  libglvnd # libGLU_combined
  openal
  libvorbis
  curl
];

in stdenv.mkDerivation rec {
  name = "assaultcube-reloaded";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/acreloaded/acr/releases/download/v2.7/acr_02_07_00-l.zip";
    sha256 = "116b0w8mil50pm766lc1f4mgvlqghlraqd80sx233ckapn6b3dvs";
  };

  # Shitty workaround because Nix is dumb.
  sourceRoot = ".";

  nativeBuildInputs = [ pkgs.unzip autoPatchelfHook ];

  buildInputs = ([ pkgs.makeWrapper ] ++ deps);

  libPath = stdenv.lib.makeLibraryPath ([ stdenv.cc.cc ] ++ deps);

  installPhase = ''
    mkdir -p $out/bin/ $out/opt/

    # Extract data
    unzip $src -d $out/opt/

    # Install and patch binaries
    for f in $src/bin_unix/*; {
      install -m755 -D $f $out/opt/bin_unix/$f
    }

    # Mark as executable
    chmod -R +x $out/opt/*.sh
    chmod -R +x $out/opt/bin_unix/*

    # Wrap launch scripts
    makeWrapper $out/opt/client.sh $out/bin/acr_client \
      --set LD_LIBRARY_PATH $libPath
    makeWrapper $out/opt/server.sh $out/bin/acr_server
  '';

  meta = {
    description = "AssaultCube Reloaded game";
  };
}
