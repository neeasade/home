{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xscreenshot       = pkgs.callPackage ./pkgs/xscreenshot.nix {};
    crud              = pkgs.callPackage ./pkgs/crud.nix        {};
    sprop             = pkgs.callPackage ./pkgs/sprop.nix       {};
    xmenu             = pkgs.callPackage ./pkgs/xmenu.nix       {};
    lsc               = pkgs.callPackage ./pkgs/lsc.nix         {};
#    emacs27           = pkgs.callPackage ./pkgs/emacs27.nix     {};

    xkeysnail         = pkgs.callPackage ./pkgs/xkeysnail.nix {
      buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
      fetchPypi = pkgs.python3Packages.fetchPypi;
      pythonPackages = pkgs.python3Packages;
    };

    acr               = pkgs.callPackage ./pkgs/acr.nix         {};

    scroll            = pkgs.callPackage ./pkgs/scroll.nix      {};
    wendy             = pkgs.callPackage ./pkgs/wendy.nix       {};
    ircdiscord        = pkgs.callPackage ./pkgs/ircdiscord.nix  {};

    charter           = pkgs.callPackage ./pkgs/charter.nix     {};
    openmoji          = pkgs.callPackage ./pkgs/openmoji.nix    {};
    scientifica       = pkgs.callPackage ./pkgs/scientifica.nix {};
    verily-serif-mono =
      pkgs.callPackage ./pkgs/verilyserifmono.nix {};

    raleigh-reloaded-gtk-theme =
      pkgs.callPackage ./pkgs/raleigh-reloaded-gtk-theme.nix {};
  };
}
