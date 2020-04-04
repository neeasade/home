{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./viz.nix
      ./pkgs.nix
  ];

  boot = {
     kernelPackages = pkgs.linuxPackages_latest;
     loader = {
       systemd-boot = {
         enable = true;
         configurationLimit = 25;
         editor = false;
       };
       timeout = 1;
       efi.canTouchEfiVariables = true;
     };
     blacklistedKernelModules = [ 
       "bluetooth" "uvcvideo" # You don't really need this, do you?
       "pcspkr" # Annoying
     ];
     kernelModules = [
       "fuse" # One of the most coolest thing
       "kvm-intel"
     ];
     consoleLogLevel = 2;
     tmpOnTmpfs = true;
  };

  networking = {
    hostName = "astatine";
    nameservers = [ "1.1.1.1" ];
    wireless = {
      enable = true;
      networks = {
        "Not Your Wifi" = {
          pskRaw = "248567fa391aaa867b6c61c99bd093e30f90be440d6b455fd0068645733fb919";
        };
      };
    };
    useDHCP = false;
    interfaces.enp1s0.useDHCP = false; # Don't need ethernet at all times
    interfaces.wlp2s0.useDHCP = true;
  };

  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "Asia/Calcutta";

  services = {
    tlp.enable = true;
    udisks2.enable = false;
    xserver = {
      enable = true;
      autorun = false;
      startDbusSession = false; # DBus can FUCK OFF
      libinput = {
        enable = true;
        disableWhileTyping = true;
      };
      videoDrivers = [ "vesa" "intel" ];
      layout = "us";
      displayManager.lightdm.enable = false; # DMs are for sissies!
      displayManager.startx.enable = true;
      # Prevent screentearing or try to
      extraConfig = ''
        Section "Device"
          Identifier "Intel"
          Driver "intel"
          Option "TearFree" "true"
          Option "VSync" "true"
        EndSection
      '';
      # Swap escape and capslock (otherwise known as the useless key)
      xkbOptions = "caps:swapescape";
    };
  };

  sound = {
    enable = true;
    # Enable ALSA's mixer. Lets multiple programs play audio at once
    extraConfig = ''
      pcm.dsp {
      	type plug
      	slave.pcm "dmix"
      }
    '';
  };

  hardware = {
    opengl.enable = true;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash"; # Really? This isn't the default binsh?
    systemPackages = with pkgs; [
      file gnumake clang pkg-config dash
      vis # The only good editor
    ];
    etc = {
       "doas.conf" = {
         enable = true;
         text = ''
           permit nopass root as root
           permit keepenv persist viz as root
           permit nopass keepenv viz as root cmd /home/viz/bin/brness
         '';
       };
    };
  };

  fonts = {
    fonts = [ pkgs.go-font ];
    fontconfig = {
      defaultFonts = {
        emoji = []; # Emojis are annoying anyway
        monospace = [ "Go Mono" ]; # The only good monospace font
        sansSerif = [ "Go" ];
        serif = [ "Go" ];
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  security = {
    polkit.enable = true; # Nixos sucks
    sudo.enable = false; # sudo is overly complicated for what I need
  };

  # Disable that annoying popup window
  programs.ssh = {
    askPassword = "";
    extraConfig = ''
      UserKnownHostsFile ~/lib/ssh/known_hosts
      ControlPath ~/lib/ssh/master-%r@%n:%p
      IdentityFile ~/lib/ssh/id_rsa
    '';
  };

  nixpkgs = {
    overlays = [ (import ./override.nix) ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment? Yes, I did.
}
