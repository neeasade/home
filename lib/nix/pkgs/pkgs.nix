{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xscreenshot = pkgs.callPackage ./xscreenshot.nix {};
    crud = pkgs.callPackage ./crud.nix {};
    sprop = pkgs.callPackage ./sprop.nix {};
  };
}
