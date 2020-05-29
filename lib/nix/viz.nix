{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "03b4f81679456dc565722b38b18c27911b135d66";
    ref = "master";
  };
in
{
  imports = [ "${home-manager}/nixos" ];

  users.users.viz = {
    name = "viz";
    isNormalUser = true;
    extraGroups = [ "viz" "wheel" "audio" "video" "input" ];
    home = "/home/viz";
    password = "nicetry";
    shell = pkgs.mksh;
  };

  home-manager.users.viz = {
    home.packages = with pkgs; [
        mpv git xclip farbfeld clang-tools slock ffmpeg transmission socat
        wget curl file gnumake gcc zathura
        xdotool xorg.xprop xorg.xrandr sxhkd gnupg pinentry-gnome
        racket-minimal go lua python3 chicken gnutls # For circe
        dwm dmenu st tabbed bgs doas lemonbar-xft wmutils-core meh
        (texlive.combine { inherit (texlive)
          scheme-minimal
          collection-latex
          collection-binextra
          collection-latexextra
          collection-pictures
          collection-latexrecommended
          collection-formatsextra
          collection-langenglish
          collection-mathscience
          ;
        })
        # Custom packages
        xscreenshot crud sprop wchf xmenu xruler lsc emacs27
        raleigh-reloaded-gtk-theme wendy ircdiscord
    ];

    home.sessionVariables = {
      INPUTRC = "\$HOME/lib/inputrc";
      ENV = "\$HOME/lib/kshrc";
      PATH = "\$HOME/bin:\$PATH";
      LESSHISTFILE = "\$XDG_CACHE_HOME/lesshst";
      GOPATH = "\$HOME/opt/go:\$HOME/src/go";
      EDITOR = "vis";
      VISUAL = "vis";
      MANPAGER = "less";
      PYTHONUSERBASE = "\$HOME/opt/python";
      PYTHONPATH = "\$HOME/opt/python";
      MANPATH = "/run/current-system/sw/share/man:\$HOME/.nix-profile/share/man";
    };

    home.file = {
      "lib/inputrc".text = "set editing-mode vi";

      "lib/vis/fennel.lua".source = "${builtins.fetchurl
         https://raw.githubusercontent.com/bakpakin/Fennel/master/fennel.lua}";
      "lib/vis/visrc.lua".text = ''
        local fennel = require("./fennel")
        fennel.path = fennel.path .. ";/home/viz/lib/vis/?.fnl"
        table.insert(package.loaders or package.searchers, fennel.searcher)
        require("cfg")
      '';

      ".irssi/passwd" = {
        text = ''
          Freenode : pass get irc/Freenode
          MadHouse : pass get irc/MadHouse
        '';
      };
      ".irssi/scripts/autorun/passwd.pl".source = "${builtins.fetchurl
          https://raw.githubusercontent.com/gandalf3/irssi-passwd/master/passwd.pl}";

      "lib/ruler/rulerrc" = {
        text = ''
          name=".*"
            drawin ruler $RULER_WID
          role="browser"
            grep -q '2' /tmp/info/wm/groups/cur || { \
                  waitron window_focus $RULER_WID && \
                          waitron group_move_window 2 \
            }
          instance="mpv-popup"
            mpopv $RULER_WID
        '';
      };
    };

    xdg = {
      enable = true;
      cacheHome = "/home/viz/.cache";
      configHome = "/home/viz/lib";
      dataHome = "/home/viz/opt";
      userDirs = {
        enable = true;
        desktop = "/no";
        documents = "/no";
        download = "\$HOME/tmp";
        music = "\$HOME/med/mus";
        pictures = "\$HOME/med/img";
        publicShare = "/no";
        templates = "/no";
        videos = "\$HOME/med/vid";
      };
    };

    # Sweet sweet DRM'd content
    nixpkgs = {
      config = {
        allowUnfree = true;
        chromium.enableWideVine = true;
      };
    };
    xdg.configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        chromium.enableWideVine = true;
      }
    '';

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userEmail = "visuwesh@tutanota.com";
        userName = "viz";
      };

      mpv = {
        enable = true;
        config = {
          audio-display = "no";

          osd-font = "Go";
          osd-font-size = 20;

          sub-font = "Go";
          sub-font-size = 20;
          sub-color = "#ffffff";
          sub-border-color = "#000000";
          sub-border-size = 2;
          # Doesn't always work. Subtitle file can hardcode size using /fs
          sub-ass-force-style = "Fontname=Go,Fontsize=20";
          embeddedfonts = "no";

          ytdl-format = "bestaudio+bestvideo";
        };
      };

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

      # Irssi is patched. See override.nix
      irssi = {
        enable = false;
        networks."Freenode" = {
          nick = "_viz_";
          autoCommands = [
            "/passwd Freenode /msg NickServ identify <password>"
          ];
          server = {
            address = "chat.freenode.net";
            port = 6697;
            autoConnect = true;
          };
          channels = {
            nixos.autoJoin = true;
            nixhub.autoJoin = true;
            unixporn.autoJoin = true;
            vis-editor.autoJoin = true;
          };
        };
        networks."MadHouse" = {
          nick = "_viz_";
          autoCommands = [
            "/passwd MadHouse /msg NickServ IDENTIFY <password>"
          ];
          server = {
            address = "irc.astrak.co";
            port = 6697;
            autoConnect = true;
            ssl.verify = false;
          };
          channels = {
            mh-general.autoJoin = true;
            mh-linux.autoJoin = true;
            mh-unixporn.autoJoin = true;
            mh-memes.autoJoin = true;
            mh-scripting.autoJoin = true;
          };
        };
      };

      zathura = {
        enable = true;
        options = {
          default-bg = "#ffffea";
          default-fg = "#1c1c1d";
          statusbar-bg = "#eaffff";
          statusbar-fg = "#1c1c1d";
          inputbar-bg = "#eaffff";
          inputbar-fg = "#1c1c1d";
          completion-bg = "#e9fee9";
          completion-fg = "#000000";
          completion-group-bg = "#e9fee9";
          completion-group-fg = "#000000";
          completion-highlight-bg = "#438743";
          completion-highlight-fg = "#e9fee9";
          index-bg = "#e9fee9";
          index-fg = "#000000";
          index-active-bg = "#438743";
          index-active-fg = "#e9fee9";
          recolor-lightcolor = "#ffffea";
          recolor-darkcolor = "#1c1c1d";

          recolor = true;
          guioptions = "";
          font = "serif normal 10";
        };
        extraConfig = "map q abort";
      };
    };

    gtk = {
      enable = true;
      font.name = "sans-serif";
      iconTheme.name = "Adwaita";
      iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
      theme.name = "Raleigh-Reloaded";
    };

    systemd.user.startServices = true;

    xsession = {
      enable = true;
      initExtra = ''
        echo $! >~/tmp/asdf
        export PATH=$HOME/bin/emacs:$HOME/bin/x:$PATH
        remkd /tmp/info/{,vol}
        . $XDG_CACHE_HOME/wall &
        pmenu &
        ruler &
        sxhkd &
        emacs --daemon &
      '';
      scriptPath = "lib/xsession";
      windowManager.command = "${pkgs.wchf}/bin/wchf";
    };

    # TODO: Find out how to load services.
    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };

      #redshift = {
      #  enable = true;
      #  latitude = "22.56";
      #  longitude = "88.36";
      #};

      sxhkd = {
        enable = true;
        extraPath = "/home/viz/bin/x";
        keybindings = {
          "alt + p" = "`menu run`";
          "alt + shift + Return" = "eterm || tab -w st";
          "super + {v,l,m,o}" = "{chromium,slock,mus,org-capture}";
          "super + {x,e}" = "{turnoff,tab --parent-id emacsclient -c -a ''}";
          "alt + shift + f" = "dmenu_dir -h 1";
          "alt + shift + ctrl + f" = "dmenu_dir -h 0";
          "Print" = "screenshot -s";
          "super + Print" = "screenshot -u";
          "super + shift + {k,j,m}" = "vol {-i 1%,-d 1%,-t}";
          "super + shift + {l,h}" = "doas ~/bin/brness {-i 1,-d 1}";
          "super + shift + {b,t}" = "notify-send {battery `bat -p`%,"
              + "time `date +%H:%M`}";
          "super + shift + {v,p}" = "notify-send {volume `vol -g`%,"
              + "`mus pprint`}";
          "super + shift + r" = "pkill -USR1 redshift";
          "super + shift + f" = "flashfocus";
          "alt + s" = "~/tmp/tst";
          "alt + [" = "plumb";

          "super + {w,a,s,d}" = "waitron window_move {0 -20,-20 0,0 +20,+20 0}";
          "super + shift + {w,a,s,d}" = "waitron window_move {0 -50,-50 0,"
              + "0 +50,+50 0}";
          "super + ctrl + {w,s,d,a}" = "waitron window_resize {0 -20,0 +20,"
              + "+20 0,-20 0}";
          "super + ctrl + shift + {w,s,d,a}" = "waitron window_resize {0 -50,"
              + "0 +50,+50 0,-50 0}";
          "alt + {c,f}" = "waitron window_{snap middle,maximize}";
          "super + p" = "wmenu";
          "alt + shift + c" = "waitron window_close";
          "alt + {h,j,k,l}" = "waitron window_cardinal_focus "
              + "{left,down,up,right}";
          "alt + shift + q" = "\$HOME/lib/wchf/wchfrc";
          "alt + shift + ctrl + q" = "waitron wm_quit 0";
          "alt + {1-5}" = "waitron group_activate_specific {1-5}";
          "alt + shift + {1-5}" = "waitron group_move_window {1-5}";
          "alt + ctrl + {1-5}" = "waitron group_activate {1-5}";
        };
      };
    };
  };

  security.wrappers = {
    slock.source = "${pkgs.slock.out}/bin/slock";
    doas.source = "${pkgs.doas.out}/bin/doas";
  };
}
