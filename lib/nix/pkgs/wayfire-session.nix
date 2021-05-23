{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "wayfire-session";
  version = "1";
  passthru.providedSessions = [ "vz-wayfire" ];
  src = ./.;

  installPhase = ''
    mkdir -p $out/{share/wayland-sessions,bin}
    cat >$out/bin/vz-wayfire <<EOF
    #!/bin/sh
    #[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ] &&
      . /home/viz/.nix-profile/etc/profile.d/hm-session-vars.sh
    systemctl --user stop graphical-session.target graphical-session-pre.target
    systemctl --user import-environment PATH XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME SSH_AUTH_SOCK XAUTHORITY XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID
    systemctl --user start wayfire-session.target
    ${pkgs.dbus}/bin/dbus-run-session ${pkgs.wayfire}/bin/wayfire
    dbus-update-activation-environment --all
    systemctl --user start graphical-session-pre.target graphical-session.target
    EOF
    chmod +x $out/bin/vz-wayfire
    cat >$out/share/wayland-sessions/vz-wayfire.desktop <<EOF
    [Desktop Entry]
    Name=Wayfire
    Exec=$out/bin/vz-wayfire
    TryExec=$out/bin/vz-wayfire
    Icon=
    Type=Application
    DesktopNames=Wayfire
    EOF
  '';
}
