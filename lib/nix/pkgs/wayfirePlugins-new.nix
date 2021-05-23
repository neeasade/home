{ newScope, wayfire }:

let
  self = with self; {
    inherit wayfire;

    callPackage = newScope self;

    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix {};
  };
in
self
