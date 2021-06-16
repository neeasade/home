{ config, pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
    };
  };
}
