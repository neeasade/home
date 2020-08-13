{ pkgs, ... }:

{
  enable = true;
  initExtra = ''
    export PATH=$HOME/bin/emacs:$HOME/bin/x:$PATH
    remkd /tmp/info/{,vol}
    . $XDG_CACHE_HOME/wall &
    pmenu &
    ruler &
    sxhkd &
    emacs --daemon &
  '';
  scriptPath = "lib/xsession";
  windowManager.command = "${pkgs.wchf.out}/bin/wchf";
}
