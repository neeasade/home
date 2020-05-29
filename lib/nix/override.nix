self: super: rec {
  tabbed = super.tabbed.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/tabbed";
      rev = "40bcf08acd5d8f7bb1b3772243ee4a10d6ad6ce1";
      ref = "master";
    };
  });

  st = super.st.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/st";
      rev = "55b7dd4fac07de7ea1b9465de14b3c15bef362be";
      ref = "master";
    };
  });

  dmenu = super.dmenu.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/vizs/dmenu";
      rev = "eefcf76dbe130f6d00727ce51b51a5340253087e";
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
      rev = "7648280a95954304e5e935e2cead16d836b86eda";
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
      rev = "396762917298f12473ec0c94a8e76d103b544f49";
      ref = "xft-port";
    };
    buildInputs = oldAttrs.buildInputs ++ (with super.xorg; [
      xcbutilwm xcbutilrenderutil
    ]);
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
    buildInputs = oldAttrs.buildInputs ++ (with super.xorg; [
      xcbutilcursor xcbutil
    ]);
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
    patches = [
      "${builtins.fetchurl https://raw.githubusercontent.com/gandalf3/" 
        + "irssi-passwd/master/irssi-connection-set-key.patch}"
    ];
  });
}
