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
    pmenu &
    emacs --daemon
  '';

  scriptPath = "lib/xsession";
}
