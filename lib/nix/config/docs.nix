# TODO: Maybe disable docs too?

{ config, pkgs, ... }:

{
  documentation = {
    info.enable = true;
    dev.enable  = true;
  };

  environment.systemPackages = with pkgs; [ manpages ];
}
