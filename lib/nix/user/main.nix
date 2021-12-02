# User configuration

{ config, lib, pkgs, ... }:

# Fetch home-manager
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    rev = "ca7868dc2977e2bdb4b1c909768c686d4ec0a412";
    ref = "master";
  };

  rycee = builtins.fetchGit {
    url = "https://gitlab.com/rycee/nur-expressions";
    rev = "d01502ec87df050d03bbe65fa482e8b1091e8191";
    ref = "master";
  };

  # nixpkgs-wayland = builtins.fetchGit {
  #   url = "https://github.com/colemickens/nixpkgs-wayland";
  #   rev = "9354b29893139d6ed98b4374521a3042e1b30626";
  #   ref = "master";
  # };

  emacs-overlay = builtins.fetchGit {
    url = "https://github.com/nix-community/emacs-overlay";
    rev = "0c42763e54d656473deef733703f224351296b13";
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
    ../config/battery.nix
    ../pkgs.nix

    "${home-manager}/nixos"
  ];

  # I prefer doas over sudo
  security = {
    sudo.enable = false;
    doas = {
      enable = false;
      extraRules = [
        {
          users = [ "viz" ];
          keepEnv = true;
          setEnv = [ "PATH" ];
          runAs = "root";
        }
        {
          users = [ "viz" ];
          noPass = true;
          keepEnv = true;
          runAs = "root";
          cmd = "/home/viz/bin/brness";
        }
      ];
    };
    wrappers = {
      doas.source = "${pkgs.doas.out}/bin/doas";
      slock.source     = "${pkgs.slock.out}/bin/slock";
      xkeysnail.source = "${pkgs.xkeysnail.out}/bin/xkeysnail";
    };
  };

  environment.etc."doas.conf" = {
    enable = true;
    text = ''
      permit nopass root as root
      permit keepenv viz as root
      permit keepenv nopass viz as root cmd /home/viz/bin/brness
    '';
  };

  # Add my overlay
  nixpkgs.overlays = [
    (import ../override.nix)
    (import "${rycee}/overlay.nix")
    # (import "${nixpkgs-wayland}")
    (import "${emacs-overlay}")
  ];
  nixpkgs.config.allowUnfree = true;

  # Setup the global environment
  environment = {
    systemPackages = [ pkgs.dash ];
    shellAliases = lib.mkForce {};
  };

  programs = {
    ssh = {
      askPassword = "";         # Disables the annoying popup window
      extraConfig = ''
      UserKnownHostsFile ~/lib/ssh/known_hosts
      ControlPath        ~/lib/ssh/master-%r@%n:%p
      IdentityFile       ~/lib/ssh/id_rsa
    '';
    };

    # ls -F > colours (Sometimes I regret this when I realise that I
    # have to edit the text after paths when in M-x shell)
    bash = {
      enableLsColors = false;
      enableCompletion = false;
    };
  };

  hardware.opengl.enable = true;

  users.groups.viz = {};
  users.users.viz = {
    name = "viz";
    group = "viz";
    isNormalUser = true;
    extraGroups = [
      "adbusers"
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
    imports = [
      ./modules/wchf.nix
      ./modules/ruler.nix
      ./modules/sxhkd-fix.nix
      ./modules/mksh.nix
      ./modules/mlvwm.nix
      # ./modules/wayfire.nix
      # ./modules/kdeconnect.nix
    ];

    home.packages = import ./packages.nix pkgs;
    home.sessionVariables = import ./envvars.nix;

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
      iconTheme.name    = "hicolor";
      iconTheme.package = pkgs.hicolor-icon-theme;
      theme.name        = "Raleigh-Reloaded";
      gtk3 = {
        bookmarks = [
          "file:///home/viz/doc/uni"
          "file:///home/viz/doc/uni/refb"
          "file:///home/viz/doc/books"
        ];
        extraConfig = {
          gtk-primary-button-warps-slider = true;
        };
      };
    };

    programs = {
      home-manager.enable = true;
      emacs = {
        enable = true;
        package = pkgs.emacsGcc;
        # extraPackages = self: [
        #   self.pkgs.gnutls      # For circe to work properly
        # ];
      };

      info.enable = true;       # This should make Emacs detect its info files properly

      bash    = import ./bash.nix;
      git     = import ./git.nix;
      mpv     = import ./mpv.nix { pkgs = pkgs; };
      irssi   = import ./irssi.nix;
      zathura = import ./zathura.nix;
      mksh    = import ./mksh.nix pkgs;

      # kdeconnect.enable = true;
      firefox = import ./firefox/firefox.nix { lib = lib; pkgs = pkgs; };

      # wayfire = import ./wayfire.nix { pkgs = pkgs; config = config; };

      chromium = {
        enable = true;
        package = (pkgs.ungoogled-chromium.override {
          enableWideVine = true;
        }); # no more :gnutroll:
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
          { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
          { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # RES
          { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
          { id = "mpbjkejclgfgadiemmefgebjfooflfhl"; } # Buster
          { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # ClearURLs
          { id = "pmcmeagblkinmogikoikkdjiligflglb"; } # Privacy Redirect
          { id = "dnhjklgpiifbofihffldllbcopkinlod"; } # Remove Google Redirection
          { # Bypass paywall
            id = "dcpihecpambacapedldabdbpakmachpb";
            updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
          }
        ];
      };
    };

    services = {
      kdeconnect.enable = true;
      sxhkd = import ./sxhkd.nix;
      ruler = import ./ruler.nix;
      dunst = import ./notifications.nix pkgs;
      # clipmenu.enable = true;

      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };

      redshift = {
        enable = true;
        latitude  = toString config.location.latitude;
        longitude = toString config.location.longitude;
        # package = pkgs.redshift-wlr;
      };

      gammastep = {
        latitude  = toString config.location.latitude;
        longitude = toString config.location.longitude;
      };

      emacs = {
#        enable = true;
        socketActivation.enable = true;
      };
    };
  };
}
