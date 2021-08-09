{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xscreenshot       = pkgs.callPackage ./pkgs/xscreenshot.nix {};
    crud              = pkgs.callPackage ./pkgs/crud.nix        {};
    sprop             = pkgs.callPackage ./pkgs/sprop.nix       {};
    xmenu             = pkgs.callPackage ./pkgs/xmenu.nix       {};
    lsc               = pkgs.callPackage ./pkgs/lsc.nix         {};
    weylus            = pkgs.callPackage ./pkgs/weylus.nix      {};
    mlvwm = pkgs.callPackage ./pkgs/mlvwm.nix {};

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
    et-book-fonts = pkgs.callPackage ./pkgs/et-book.nix {};
    openmoji          = pkgs.callPackage ./pkgs/openmoji.nix    {};
    scientifica       = pkgs.callPackage ./pkgs/scientifica.nix {};
    verily-serif-mono =
      pkgs.callPackage ./pkgs/verilyserifmono.nix {};

    raleigh-reloaded-gtk-theme =
      pkgs.callPackage ./pkgs/raleigh-reloaded-gtk-theme.nix {};

    hunspellDicts.en-academic = pkgs.callPackage ./pkgs/hunspellDicts.en-academic.nix {};
    hunspellDicts.en-gb-ise =
      (pkgs.hunspellDicts.en_GB-ise.overrideAttrs (_: {
        version = "2020.12.07";
        src = builtins.fetchurl {
          url = "mirror://sourceforge/wordlist/speller/2020.12.07/hunspell-en_GB-ise-2020.12.07.zip";
          sha256 = "1lqsy2szmwbgf9c7fhqpmw6rjnzn8d8mpdyv82sw726ir4p4pv9c";
        };
      }));

    wayfirePlugins = pkgs.recurseIntoAttrs (
      pkgs.callPackage ./pkgs/wayfirePlugins-new.nix {
        inherit (pkgs.wayfireApplications-unwrapped) wayfire;
      }
    );

    wayfire-session = pkgs.callPackage ./pkgs/wayfire-session.nix {};

    session-desktop = pkgs.callPackage ./pkgs/session-desktop.nix {};
  };
}
