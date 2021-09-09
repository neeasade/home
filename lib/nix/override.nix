self: super: rec {
  drawing = super.drawing.overrideAttrs (old: rec {
    version = "0.8.3";
    src = super.fetchFromGitHub {
      owner = "maoschanz";
      repo = old.pname;
      rev = version;
      sha256 = "0wz9p47riyy3h8b0sqsb6bx416hc6d1a1wyzlfmsxkrqrkwcjcm8";
    };
    patches = [
      patches/drawing/0001-Disable-changelog-message.patch
      patches/drawing/0002-Don-t-open-a-new-blank-window.patch
    ];
  });

  # WHY IS IT SO OUTDATED?!??!?!??!?
  # hunspellDicts = super.hunspellDicts // {
  #   en-gb-ise = super.hunspellDicts.en-gb-ise.overrideAttrs (_: {
  #     version = "2020.12.07";
  #     src = builtins.fetchurl {
  #       url = "mirror://sourceforge/wordlist/speller/2020.12.07/hunspell-en_GB-ise-2020.12.07.zip";
  #       sha256 = "1lqsy2szmwbgf9c7fhqpmw6rjnzn8d8mpdyv82sw726ir4p4pv9c";
  #     };
  #   });
  # };

  awesome = super.awesome.override {
    gtk3Support = true;
  };

  #  emacs = super.emacs.override {
  #    withXwidgets = true;
  #  };

  tabbed = super.tabbed.overrideAttrs (_: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/tabbed";
      rev = "40bcf08acd5d8f7bb1b3772243ee4a10d6ad6ce1";
      ref = "master";
    };
  });

  # st = super.st.overrideAttrs (_: {
  #   src = builtins.fetchGit {
  #     url = "https://github.com/odknt/st";
  #     rev = "3f97e54e4374ecfad2a5044367b5348896039dc3";
  #     ref = "master";
  #   };
  #   buildInputs = with super.pkgs; [
  #     xorg.libX11
  #     cairo
  #     freetype
  #     fontconfig
  #   ];
  #   patches = [
  #     # ./patches/st/001-config.patch
  #   ];
  # });

  dmenu = super.dmenu.overrideAttrs (_: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/dmenu";
      rev = "1c3ebd8790b5c8f225cd58fb897c8dbc382c76e6";
      ref = "master";
    };
    patches = [];
  });

  dwm = super.dwm.overrideAttrs (_: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/dwm";
      rev = "3f8b7fb8033ead7488c5629e4d131b80d7661ed7";
      ref = "master";
    };
  });

  bgs = super.bgs.overrideAttrs (_: {
    version = "git";
    src = builtins.fetchGit {
      url = "https://github.com/Gottox/bgs";
      rev = "958acea074e5d8f3566289db37a9db236c05d7df";
      ref = "master";
    };
    patches = [
      ./patches/bgs/001-fix_zoom_mode.patch
      ./patches/bgs/002-add_tiling_mode.patch
    ];
  });

  # The latest release is way too outdated
  vis = super.vis.overrideAttrs (_: {
    version = "git";
    src = builtins.fetchGit {
      url = "https://github.com/martanne/vis";
      rev = "7648280a95954304e5e935e2cead16d836b86eda";
      ref = "master";
    };
  });

  doas = super.doas.overrideAttrs (_: {
    src = builtins.fetchGit {
      url = "https://github.com/multiplexd/doas";
      rev = "4c8ab4c372e3b3c6d051f298b0bda03575f79f96";
      ref = "master";
    };
    buildInputs = with super; [ bison ];
    postPatch = "";
    installPhase = ''
      mkdir -p $out/bin $out/man/man1
      cp doas $out/bin
      cp doas.1 $out/man/man1
    '';
  });

  lemonbar-xft = super.lemonbar-xft.overrideAttrs (old: {
    version = "git";
    src = builtins.fetchGit {
      url = "https://github.com/vizs/bar";
      rev = "396762917298f12473ec0c94a8e76d103b544f49";
      ref = "xft-port";
    };
    buildInputs = old.buildInputs ++ (with super.xorg; [
      xcbutilwm xcbutilrenderutil
    ]);
    prePatch = "";
    preConfigure = ''
      sed -i "s|PREFIX?=/usr/local|PREFIX = $out|" Makefile
    '';
  });

  mksh = super.mksh.overrideAttrs (_: {
    patches = [
      ./patches/mksh/001-shellrc_path.patch
      ./patches/mksh/002-profile_path.patch
    ];
  });

  wmutils-core = super.wmutils-core.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ (with super.xorg; [
      xcbutilcursor xcbutil
    ]);
    src = builtins.fetchGit {
      url = "https://github.com/wmutils/core";
      rev = "2a8ee9d061996cef9567a30821249c3d06557419";
      ref = "master";
    };
  });

  meh = super.meh.overrideAttrs (_: {
    patches = [ ./patches/meh/001-set_class_hints.patch ];
  });

  irssi = super.irssi.overrideAttrs (_: {
    patches = [
      "${builtins.fetchurl https://raw.githubusercontent.com/gandalf3/"
        + "irssi-passwd/master/irssi-connection-set-key.patch}"
    ];
  });
}
