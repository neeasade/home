{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # Very basic configuration
    ./basic.nix
    # Everything else
    ./user/user.nix
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # should.
  system.stateVersion = "19.09"; # Did you read the comment? Yes, I did.
}
