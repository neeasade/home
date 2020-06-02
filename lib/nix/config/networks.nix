# Wifi networks and things

{ config, ... }:

{
  networking = {
    hostName = "astatine";
    nameservers = [ "1.1.1.1" ];

    wireless = {
      enable = true;
      networks."Not Your Wifi".pskRaw =
        "248567fa391aaa867b6c61c99bd093e30f90be440d6b455fd0068645733fb919";
    };

    # Should be set to false from NixOS 19+
    useDHCP = false;

    interfaces = {
      # Disable ethernet?
      enp1s0.useDHCP = false;
      wlp2s0.useDHCP = true;
    };
  };
}
