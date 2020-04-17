self: super: rec {
  tabbed = super.tabbed.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/tabbed";
      rev = "7d6fd8ddf18ddff4b1ee5899d972b1b17d73c557";
      ref = "master";
    };
  });

  st = super.st.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/st";
      rev = "93336f783916225cb102fd75133c32530481d970";
      ref = "master";
    };
  });

  dmenu = super.dmenu.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/dmenu";
      rev = "ee3360a093533ac0dc5eb5ff4350b700b19c6ffb";
      ref = "master";
    };
    patches = [];
  });

  dwm = super.dwm.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/dwm";
      rev = "3f8b7fb8033ead7488c5629e4d131b80d7661ed7";
      ref = "master";
    };
  });

  bgs = super.bgs.overrideAttrs (oldAttrs: {
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
  vis = super.vis.overrideAttrs (oldAttrs: {
    version = "git";
    src = builtins.fetchGit {
      url = "https://github.com/martanne/vis";
      rev = "08a550deac6f55f32f131f66992994b3944011ce";
      ref = "master";
    };
  });

  doas = super.doas.overrideAttrs (oldAttrs: {
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

  lemonbar-xft = super.lemonbar-xft.overrideAttrs (oldAttrs: {
    version = "git";
    src = builtins.fetchGit {
      url = "https://github.com/vizs/bar";
      rev = "35a89711a311ee0905d797a60079c79bae32ed76";
      ref = "xft-port";
    };
    buildInputs = with super; [
      xorg.libxcb
      xorg.libXft
      perl
      xorg.xcbutilwm
      xorg.xcbutilrenderutil
    ];
    prePatch = "";
    preConfigure = ''
      sed -i "s|PREFIX?=/usr/local|PREFIX = $out|" Makefile
    '';
  });

  mksh = super.mksh.overrideAttrs (oldAttrs: {
    patches = [
      ./patches/mksh/001-shellrc_path.patch
      ./patches/mksh/002-profile_path.patch
    ];
  });

  wmutils-core = super.wmutils-core.overrideAttrs (oldAttrs: {
    buildInputs = with super; [
      xorg.libxcb xorg.xcbutil xorg.xcbutilcursor
    ];
    src = builtins.fetchGit {
      url = "https://github.com/wmutils/core";
      rev = "2a8ee9d061996cef9567a30821249c3d06557419";
      ref = "master";
    };
  });

  meh = super.meh.overrideAttrs (oldAttrs: {
    patches = [ ./patches/meh/001-set_class_hints.patch ];
  });

  irssi = super.irssi.overrideAttrs (oldAttrs: {
    patches = [ /home/viz/lib/nix/patches/irssi/001-connection_set_key.patch ];
  });
}