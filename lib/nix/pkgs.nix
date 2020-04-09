{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xscreenshot = pkgs.callPackage ./pkgs/xscreenshot.nix {};
    crud = pkgs.callPackage ./pkgs/crud.nix {};
    sprop = pkgs.callPackage ./pkgs/sprop.nix {};
    wchf = pkgs.callPackage ./pkgs/wchf.nix {};
    xmenu = pkgs.callPackage ./pkgs/xmenu.nix {};
    libwm = pkgs.callPackage ./pkgs/libwm.nix {};
    xruler = pkgs.callPackage ./pkgs/ruler.nix {};
    charter = pkgs.callPackage ./pkgs/charter.nix {};
    raleigh-reloaded-gtk-theme =
      pkgs.callPackage ./pkgs/raleigh-reloaded-gtk-theme.nix {};
  };
}
