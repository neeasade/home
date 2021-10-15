{
  ENV            = "\$HOME/lib/kshrc";
  PATH           = "\$HOME/bin/x:\$HOME/bin/emacs:\$HOME/bin:\$PATH";
  LESSHISTFILE   = "\$XDG_CACHE_HOME/lesshst";
  GOPATH         = "\$HOME/lib/go";
  EDITOR         = "emacsclient -c";
  VISUAL         = "emacsclient -c";
  MANPAGER       = "less";
  PYTHONUSERBASE = "\$HOME/lib/python";
  PYTHONPATH     = "\$HOME/lib/python";
  # The QT file picker does not match "fuzzily."
  QT_QPA_PLATFORMTHEME = "gtk3";
  # MOZ_ENABLE_WAYLAND = "1";
  # QT_QPA_PLATFORM = "wayland";
  # SDL_VIDEODRIVER = "wayland";
}
