# Setup the very basic system configuration

{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules  = [ "fuse" "kvm-intel" ];

    # Disable bluetooth and the beep speaker
    blacklistedKernelModules = [ "btusb" "bluetooth" "pcspkr" ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 40;
        consoleMode = "keep";
        editor = false;
      };

      # Don't wait for too long
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 2;
    tmpOnTmpfs = true;
  };

  hardware = {
    bluetooth.enable = false;
    uinput.enable = true;
  };

  # Setup ALSA
  sound = {
    enable = true;
    # Enable ALSA mixer so that we can play audio from mutliple sources
    extraConfig = ''
      pcm.dsp {
        type plug
        slave.pcm "dmix"
      }
    '';
  };

  # Change /bin/sh to dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Fuck off dbus
  environment.etc = {
    "machine-id".text = "00000000000000000000000000000000\n";
  };

  # Garbage collect every two weeks
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
