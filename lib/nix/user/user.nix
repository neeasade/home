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
      shellAliases = pkgs.lib.mkForce {};
    };
  };

  users.groups.viz = {};
  users.users.viz = {
    name = "viz";
    group = "viz";
    extraGroups = [ "wheel" "audio" "video" "input" ];
    home = "/home/viz";
    password = "nicetry";
    shell = pkgs.bash;
  };

  home-manager.users.viz = {
    home.packages = import ./packages.nix pkgs;

    # Environment variables
    home.sessionVariables = import ./envvars.nix;

    imports = [
      ./modules/wchf.nix
      ./modules/ruler.nix
      ./modules/sxhkd-fix.nix
    ];

    home.file = {
      "lib/inputrc".text = "set editing-mode vi";

      # Setup vis to use Fennel instead of Lua for config
      # "lib/vis/fennel.lua".source =
      #   "${builtins.fetchurl {
      #     url = "https://github.com/bakpakin/Fennel/releases/download/0.4.2/fennel";
      #     sha256 = "1c6gpnwnhp2ghklnwb3pmb73kk10l5f1d8ay2wawylq48xwx02nw";
      #   }}";
      # "lib/vis/visrc.lua".text = ''
      #   local fennel = require("./fennel")
      #   fennel.path  = fennel.path .. ";/home/viz/lib/vis/?.fnl"
      #   table.insert(package.loaders or packages.searchers,
      #                fennel.searcher)
      #   require("cfg")
      # '';

      # Profile
      #"lib/profile".text = ''
      #  . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      #  [ ''${SHELL##*/} = mksh ] && {
      #   export ENV=$HOME/lib/kshrc
      #    . $HOME/lib/kshrc
      #  }
      #'';

      "lib/directory-aliases".text = ''
        A=/home/viz/med/img/art
        B=/home/viz/bin
        C=/home/viz/.cache
        D=/home/viz/doc
        E=/home/viz/lib
        F=/home/viz/med/img/film
        K=/home/viz/lib/ksh
        M=/home/viz/med/mus
        N=/home/viz/lib/nix
        R=/home/viz/opt/repos
        S=/home/viz/src
        T=/home/viz/tmp
        W=/home/viz/med/img/walls
        a=/home/viz/med/vid/anm
        s=/home/viz/doc/school
        u=/home/viz/doc/uni
      '';
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
