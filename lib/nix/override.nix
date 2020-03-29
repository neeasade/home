self: super: rec {
  tabbed = super.tabbed.overrideAttrs (oldAttrs: {
    src = "${builtins.fetchTarball https://github.com/vizs/tabbed/archive/master.tar.gz}";
  });

  st = super.st.overrideAttrs (oldAttrs: {
    src = "${builtins.fetchTarball https://github.com/vizs/st/archive/master.tar.gz}";
  });

  dmenu = super.dmenu.overrideAttrs (oldAttrs: {
    src = "${builtins.fetchTarball https://github.com/vizs/dmenu/archive/master.tar.gz}";
    patches = [];
  });

  dwm = super.dwm.overrideAttrs (oldAttrs: {
    src = "${builtins.fetchTarball https://github.com/vizs/dwm/archive/master.tar.gz}";
  });

  bgs = super.bgs.overrideAttrs (oldAttrs: {
    version = "git";
    src = "${builtins.fetchTarball https://github.com/Gottox/bgs/archive/master.tar.gz}";
    patches = [
      ./patches/bgs/001-fix_zoom_mode.patch
      ./patches/bgs/002-add_tiling_mode.patch
    ];
  });

  # The latest release is way too outdated
  vis = super.vis.overrideAttrs (oldAttrs: {
    version = "git";
    src = "${builtins.fetchTarball https://github.com/martanne/vis/archive/master.tar.gz}";
  });

  doas = super.doas.overrideAttrs (oldAttrs: {
    src = "${builtins.fetchTarball https://github.com/multiplexd/doas/archive/4c8ab4c.tar.gz}";
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
    src = "${builtins.fetchTarball https://github.com/vizs/bar/archive/xft-port.tar.gz}";
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
}
