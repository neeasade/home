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
    # . $XDG_CACHE_HOME/wall &
    # pmenu &
    emacs --daemon
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
  };
}
