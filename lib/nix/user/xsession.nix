{ pkgs, ... }:

{
  enable = true;

  importedVariables = [
    "PATH"
    "XDG_CONFIG_HOME"
    "XDG_DATA_HOME"
    "XDG_CACHE_HOME"
  ];

  initExtra = ''
    remkd /tmp/info/{,vol}
    . $XDG_CACHE_HOME/wall &

     # -twokey: by default, when you press two modifiers at once, it
    # disables sticky keys permanently.  Bad behaviour for an Emacs
    # user.
    #
    # latchlock: pressing the same modifier locks it.  Very nice
    # behaviour.  For example, if you know that you're going to do a
    # lot of C- motion, then press Ctrl twice.  C-SPC C-n C-n C-w
    # becomes Ctrl Ctrl n n w.
    ${pkgs.xkbset}/bin/xkbset sticky -twokey latchlock

	  # Sticky key gets reset after a set period of time.  No good!  The
	  # default timeout is 120 s.
	  ${pkgs.xkbset}/bin/xkbset exp 120 =sticky =twokey =latchlock

    # Do not forget the '&'!  Lest you end up waiting a good five seconds
    # before you can do anything!
    emacs --daemon &
  '';

  scriptPath = "lib/xsession";

  windowManager = {
    awesome = {
      enable = true;
      package = (pkgs.awesome.override {
        gtk3Support = true;
      });
    };

    wchf = {
      enable = false;

      config = {
        borderWidths = [ 1 5 1 ];
        borderFocusedColors = [ "7d7c7c" "ffffea" "7d7d7c" ];
        borderUnfocusedColors = [ "cccccc" "ffffea" "ffffea" ];
        enableBorders = true;

        enableSloppyFocus = true;
        enableLastWindowFocusing = true;
        enableResizeHints = true;

        numberOfGroups = 10;
        pointerModifier = "super";

        extraConfig = "waitron refresh-borders";
      };
    };

    mlvwm = {
      enable = false;
      config.initFile = ''
  Desktopnum 10
  StickyHide
  SloppyFocus
  '';
    };
  };
}
