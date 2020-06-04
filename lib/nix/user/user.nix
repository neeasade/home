# User configuration
# TODO: Services don't start for some reason

{ config, pkgs, ... }:

# Fetch home-manager
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "03b4f81679456dc565722b38b18c27911b135d66";
    ref = "master";
  };
in
{
  imports = [
    ../config/fonts.nix
    ../config/location.nix
    ../config/networks.nix
    ../config/xorg.nix
    ../pkgs.nix

    "${home-manager}/nixos"
  ];

  # I prefer doas over sudo
  security.sudo.enable = false;
  security.wrappers.doas.source = "${pkgs.doas.out}/bin/doas";

  security.wrappers.slock.source = "${pkgs.slock.out}/bin/slock";

  # Add my overlay
  nixpkgs.overlays = [ (import ../override.nix) ];

  # Setup the global environment
  environment = {
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

  programs = {
    gnupg.agent.enable = true;
    ssh = {
      # Disable the annoying popup window
      askPassword = "";
      extraConfig = ''
      UserKnownHostsFile ~/lib/ssh/known_hosts
      ControlPath        ~/lib/ssh/master-%r@%n:%p
      IdentityFile       ~/lib/ssh/id_rsa
    '';
    };
  };

  services.redshift.enable = true;

  users.groups.viz = {};
  users.users.viz = {
    name = "viz";
    group = "viz";
    extraGroups = [ "wheel" "audio" "video" "input" ];
    home = "/home/viz";
    password = "nicetry";
    shell = pkgs.mksh;
  };

  home-manager.users.viz = {
    home.packages = import ./packages.nix pkgs;

    # Environment variables
    home.sessionVariables = import ./envvars.nix;

    home.file = {
      "lib/inputrc".text = "set editing-mode vi";

      # Setup vis to use Fennel instead of Lua for config
      "lib/vis/fennel.lua".source = "${builtins.fetchurl
        https://raw.githubusercontent.com/bakpakin/Fennel/master/fennel.lua}";
      "lib/vis/visrc.lua".text = ''
        local fennel = require("./fennel")
        fennel.path  = fennel.path .. ";/home/viz/lib/vis/?.fnl"
        table.insert(package.loaders or packages.searchers,
                     fennel.searcher)
        require("cfg")
      '';

      # Ruler
      "lib/ruler/rulerrc".text = ''
        name=".*"
          drawin ruler $RULER_WID
        role="browser"
          grep -q 2 /tmp/info/wm/groups/cur || {\
          waitron window_focus $RULER_WID &&\
          waitron group_move_window 2\
          }
        instance="mpv-popup"
          mpopv $RULER_WID
      '';
    };

    systemd.user.startServices = true;

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
#         "kkkjlfejijcjgjllecmnejhogpbcigdc" # Org-capture extension
        ];
      };
    };

    services = {
      sxhkd = import ./sxhkd.nix;

      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };

#      redshift = {
#        enable = true;
#        latitude  = toString config.location.latitude;
#        longitude = toString config.location.longitude;
#      };
    };
  };
}