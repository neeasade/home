# User configuration

{ config, pkgs, ... }:

# Fetch home-manager
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    rev = "96d7de6db18d9a5bf254ddf3525bb4ef1d2a6bda";
    ref = "master";
  };
in
{
  imports = [
    ../config/fonts.nix
    ../config/location.nix
    ../config/networks.nix
    ../config/xorg.nix
    ../config/docs.nix
    ../pkgs.nix

    "${home-manager}/nixos"
  ];

  # I prefer doas over sudo
  security.sudo.enable = false;
  security.wrappers = {
    doas.source      = "${pkgs.doas.out}/bin/doas";
    slock.source     = "${pkgs.slock.out}/bin/slock";
    xkeysnail.source = "${pkgs.xkeysnail.out}/bin/xkeysnail";
  };

  # Add my overlay
  nixpkgs.overlays = [ (import ../override.nix) ];

  # Setup the global environment
  environment = {
    systemPackages = [ pkgs.dash ];
    shellAliases = pkgs.lib.mkForce {};
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

  programs = {
    ssh = {
      # Disable the annoying popup window
      askPassword = "";
      extraConfig = ''
      UserKnownHostsFile ~/lib/ssh/known_hosts
      ControlPath        ~/lib/ssh/master-%r@%n:%p
      IdentityFile       ~/lib/ssh/id_rsa
    '';
    };

    # ANNOYING!
    bash = {
      enableLsColors = false;
      enableCompletion = false;
    };
  };

  users.groups.viz = {};
  users.users.viz = {
    name = "viz";
    group = "viz";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "uinput"
    ];
    home = "/home/viz";
    password = "nicetry";
    shell = pkgs.mksh;
  };

  home-manager.users.viz = {
    home.packages = import ./packages.nix pkgs;

    # Environment variables
    home.sessionVariables = import ./envvars.nix;

    imports = [
      ./modules/wchf.nix
      ./modules/ruler.nix
      ./modules/sxhkd-fix.nix
      ./modules/mksh.nix
    ];

    home.file = {
      "lib/9fortune/terry".source =
        "${builtins.fetchurl {
          url = "https://code.9front.org/hg/plan9front/raw-file/484d3f8e5978/lib/terry";
          sha256 = "0wx7rfz9cxsa99hwdzcdz718zqmbjlr39dfqjligqcnsvra9h86b";
        }}";

      "lib/9fortune/theo".source =
        "${builtins.fetchurl {
          url = "https://code.9front.org/hg/plan9front/raw-file/484d3f8e5978/lib/theo";
          sha256 = "153smyqg0480nqb75csi9vzgdqjraml049f295hfgninv1la34il";
        }}";
    };

    xdg            = import ./xdg.nix;
    xsession       = import ./xsession.nix pkgs;
    nixpkgs.config = import ./nixpkgs.nix;

    gtk = {
      enable            = true;
      font.name         = "sans-serif";
      iconTheme.name    = "Adwaita";
      iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
      theme.name        = "Raleigh-Reloaded";
    };

    programs = {
      home-manager.enable = true;
      emacs.enable = true;

      bash    = import ./bash.nix;
      git     = import ./git.nix;
      mpv     = import ./mpv.nix;
      irssi   = import ./irssi.nix;
      zathura = import ./zathura.nix;
      mksh    = import ./mksh.nix pkgs;

      chromium = {
        enable = true;
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
          "kbmfpngjjgdllneeigpgjifpgocmfgmb" # RES
          "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        # "kkkjlfejijcjgjllecmnejhogpbcigdc" # Org-capture extension
        ];
      };
    };

    services = {
      sxhkd = import ./sxhkd.nix;
      ruler = import ./ruler.nix;

      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };

      redshift = {
        enable = true;
        latitude  = toString config.location.latitude;
        longitude = toString config.location.longitude;
      };

      xsession.windowManager.wchf = {
        enable = true;

        config = {
          borderWidths = [ 1 5 1 ];
          borderFocusedColors = [ "7d7c7c" "ffffea" "7d7d7c" ];
          borderUnfocusedColors = [ "cccccc" "ffffea" "ffffea" ];
          enableBorders = true;

          enableSloppyFocus = true;
          enableLastWindowFocusing = true;
          enableResizeHints = true;

          numberOfGroups = 5;
          pointerModifier = "super";

          extraConfig = "waitron refresh-borders";
        };
      };
    };
  };
}
