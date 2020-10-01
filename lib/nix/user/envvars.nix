{
  ENV            = "\$HOME/lib/kshrc";
  PATH           = "\$HOME/bin/emacs:\$HOME/bin/x:\$HOME/bin:\$PATH";
  LESSHISTFILE   = "\$XDG_CACHE_HOME/lesshst";
  GOPATH         = "\$HOME/opt/go";
  EDITOR         = "emacsclient";
  VISUAL         = "emacsclient";
  MANPAGER       = "less";
  PYTHONUSERBASE = "\$HOME/opt/python";
  PYTHONPATH     = "\$HOME/opt/python";
  MANPATH        = "/run/current-system/sw/share/man:"
                 + "\$HOME/.nix-profile/share/man";
}
