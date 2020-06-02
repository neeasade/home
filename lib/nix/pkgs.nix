{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xscreenshot       = pkgs.callPackage ./pkgs/xscreenshot.nix {};
    crud              = pkgs.callPackage ./pkgs/crud.nix        {};
    sprop             = pkgs.callPackage ./pkgs/sprop.nix       {};
    wchf              = pkgs.callPackage ./pkgs/wchf.nix        {};
    xmenu             = pkgs.callPackage ./pkgs/xmenu.nix       {};
    libwm             = pkgs.callPackage ./pkgs/libwm.nix       {};
    xruler            = pkgs.callPackage ./pkgs/ruler.nix       {};
    lsc               = pkgs.callPackage ./pkgs/lsc.nix         {};
    emacs27           = pkgs.callPackage ./pkgs/emacs27.nix     {};

    acr               = pkgs.callPackage ./pkgs/acr.nix         {};

    scroll            = pkgs.callPackage ./pkgs/scroll.nix      {};
    wendy             = pkgs.callPackage ./pkgs/wendy.nix       {};
    ircdiscord        = pkgs.callPackage ./pkgs/ircdiscord.nix  {};

    charter           = pkgs.callPackage ./pkgs/charter.nix     {};
    scientifica       = pkgs.callPackage ./pkgs/scientifica.nix {};
    verily-serif-mono =
      pkgs.callPackage ./pkgs/verilyserifmono.nix {};

    raleigh-reloaded-gtk-theme =
      pkgs.callPackage ./pkgs/raleigh-reloaded-gtk-theme.nix {};
  };
}
