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
       "bluetooth" "uvcvideo" "pcspkr"
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
          pskRaw = "248567fa391aaa867b6c61c99bd093e30f90be440d6b455"
            + "fd0068645733fb919";
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

  location = {
    latitude = 22.56;
    longitude = 88.36;
  };

  services = {
    dbus.packages = with pkgs; [ gnome3.dconf gcr ];
    tlp.enable = true;
    udisks2.enable = false;
    redshift.enable = true;
    xserver = {
      enable = true;
      autorun = true;
      startDbusSession = true;
      libinput = {
        enable = true;
        disableWhileTyping = true;
      };
      desktopManager.session = [{
        name = "home-manager";
        bgSession = true;
        start = ''
          ${pkgs.stdenv.shell} $HOME/lib/xsession &
          waitPID=$!
        '';
      }];
      displayManager = {
        defaultSession = "home-manager";
        lightdm = {
          enable = true;
          autoLogin = {
            enable = true;
            user = "viz";
          };
          background = "#dde0e2";
          greeter.enable = false;
        };
      };
      # displayManager.startx.enable = true;
      videoDrivers = [ "intel" ];
      layout = "us";
      extraConfig = ''
        Section "Device"
          Identifier "Intel"
          Driver "intel"
          Option "TearFree" "true"
          Option "VSync" "true"
        EndSection
      '';
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

  hardware.opengl.enable = true;

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    systemPackages = with pkgs; [ dash vis ];
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
    # If it isn't obvious yet, I like typewriter fonts
    fonts = [
      pkgs.go-font pkgs.verily-serif-mono pkgs.charter pkgs.ibm-plex
      pkgs.lmodern pkgs.lmmath pkgs.scientifica
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Verily Serif Mono"
          "Go Mono"
        ];
        sansSerif = [ "IBM Plex Sans Condensed" "Go" ];
        serif = [ "Charter" "Latin Modern Roman" ];
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.overlays = [ (import ./override.nix) ];

  security = {
    polkit.enable = true; # X needs it.
    sudo.enable = false;
  };

  programs = {
    gnupg.agent.enable = true;
    ssh = {
      # Disable that annoying popup window
      askPassword = "";
      extraConfig = ''
        UserKnownHostsFile ~/lib/ssh/known_hosts
        ControlPath ~/lib/ssh/master-%r@%n:%p
        IdentityFile ~/lib/ssh/id_rsa
      '';
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # should.
  system.stateVersion = "19.09"; # Did you read the comment? Yes, I did.
}
