{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, wrapGAppsHook, nixosTests
, gnome2, gtk3, atk, at-spi2-atk, cairo, pango, gdk-pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib
, cups, expat, libuuid, at-spi2-core, libappindicator-gtk3, mesa
# Runtime dependencies:
, systemd, libnotify, libdbusmenu, libpulseaudio
# Unfortunately this also overwrites the UI language (not just the spell
# checking language!):
, hunspellDicts, spellcheckerLanguage ? null # E.g. "de_DE"
# For a full list of available languages:
# $ cat pkgs/development/libraries/hunspell/dictionaries.nix | grep "dictFileName =" | awk '{ print $3 }'
}:

let
  customLanguageWrapperArgs = (with lib;
    let
      # E.g. "de_DE" -> "de-de" (spellcheckerLanguage -> hunspellDict)
      spellLangComponents = splitString "_" spellcheckerLanguage;
      hunspellDict = elemAt spellLangComponents 0 + "-" + toLower (elemAt spellLangComponents 1);
    in if spellcheckerLanguage != null
      then ''
        --set HUNSPELL_DICTIONARIES "${hunspellDicts.${hunspellDict}}/share/hunspell" \
        --set LC_MESSAGES "${spellcheckerLanguage}"''
      else "");
in stdenv.mkDerivation rec {
  pname = "session-desktop";
  version = "1.6.4"; # Please backport all updates to the stable channel.
  # All releases have a limited lifetime and "expire" 90 days after the release.
  # When releases "expire" the application becomes unusable until an update is
  # applied. The expiration date for the current release can be extracted with:
  # $ grep -a "^{\"buildExpiration" "${session-desktop}/lib/Session/resources/app.asar"
  # (Alternatively we could try to patch the asar archive, but that requires a
  # few additional steps and might not be the best idea.)

  src = fetchurl {
    url = "https://github.com/oxen-io/${pname}/releases/download/v${version}/${pname}-linux-amd64-${version}.deb";
    sha256 = "00nw5mma175jqqygsagg9pg0xa5np8ncjxps3bzgz4zlx1srw2mm";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libnotify
    libuuid
    mesa # for libgbm
    nspr
    nss
    pango
    systemd
    xorg.libxcb
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    libnotify
    libdbusmenu
  ];

  unpackPhase = "dpkg-deb -x $src .";

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  # We need to run autoPatchelf manually with the "no-recurse" option, see
  # https://github.com/NixOS/nixpkgs/pull/78413 for the reasons.
  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    mv usr/share $out/share
    mv opt/Session $out/lib/Session
    # Note: The following path contains bundled libraries:
    # $out/lib/Session/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/
    # We run autoPatchelf with the "no-recurse" option to avoid picking those
    # up, but resources/app.asar still requires them.
    # Symlink to bin
    mkdir -p $out/bin
    ln -s $out/lib/Session/session-desktop-bin $out/bin/session-desktop
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }"
      ${customLanguageWrapperArgs}
    )
    # Fix the desktop link
    substituteInPlace $out/share/applications/session-desktop.desktop \
      --replace /opt/Session/session-desktop $out/bin/session-desktop
    autoPatchelf --no-recurse -- $out/lib/Session/
    # patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/Session/resources/app.asar.unpacked/node_modules/ringrtc/build/linux/libringrtc.node
  '';
}
