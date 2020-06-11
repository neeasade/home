# TODO: Maybe disable docs too?

{ config, pkgs, ... }:

{
  documentation = {
    info.enable = false;
    dev.enable  = true;
  };

  environment.systemPackages = with pkgs; [ manpages ];
}
