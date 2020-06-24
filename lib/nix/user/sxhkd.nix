{
  enable = true;
  extraPath = "/home/viz/bin/x";
  keybindings = {
    "Print"         = "screenshot -s";
    "super + Print" = "screenshot -u";

    "super + r"                = "`menu run`";
    "super + shift + Return"   = "eterm || tab -w st";
    "super + shift + q"        = "\$HOME/lib/wchf/wchfrc";
    "super + shift + ctrl + q" = "waitron wm_quit 0";

    "super + v" = "chromium";
    "super + l" = "slock";
    "super + p" = "wmenu";
    "super + m" = "mus";
    "super + o" = "org-capture";
    "super + e" = "tab --parent-id emacsclient -c -a ''";

    "super + shift + r" = "pkill -USR1 redshift";
    "super + shift + f" = "flashfocus";
    "super + shift + x" = "turnoff";

    # Control
    "super + shift + k" = "vol -i 1%";
    "super + shift + j" = "vol -d 1%";
    "super + shift + m" = "vol -t";
    "super + shift + l" = "doas $HOME/bin/brness -i 1";
    "super + shift + h" = "doas $HOME/bin/brness -d 1";

    # Notifications
    "super + shift + b" = "notify-send battery `bat -p`%";
    "super + shift + t" = "notify-send time `date +%H:%M`";
    "super + shift + v" = "notify-send volume `vol -g`%";
    "super + shift + p" = "notify-send `mus pprint`";

    # Window manager
    # Move
    "super + w" = "waitron window_move   0 -20";
    "super + a" = "waitron window_move -20   0";
    "super + s" = "waitron window_move   0 +20";
    "super + d" = "waitron window_move +20   0";

    "super + shift + w" = "waitron window_move   0 -50";
    "super + shift + a" = "waitron window_move -50   0";
    "super + shift + s" = "waitron window_move   0 +50";
    "super + shift + d" = "waitron window_move +50   0";

    # Resize
    "super + ctrl + w" = "waitron window_resize   0 -20";
    "super + ctrl + a" = "waitron window_resize -20   0";
    "super + ctrl + s" = "waitron window_resize   0 +20";
    "super + ctrl + d" = "waitron window_resize +20   0";

    "super + shift + ctrl + w" = "waitron window_resize    0 -50";
    "super + shift + ctrl + a" = "waitron window_resize  -20   0";
    "super + shift + ctrl + s" = "waitron window_resize    0 +50";
    "super + shift + ctrl + d" = "waitron window_resize  +20   0";

    # Focus
    "super + ctrl + h" = "waitron window_cardinal_focus left";
    "super + ctrl + j" = "waitron window_cardinal_focus down";
    "super + ctrl + k" = "waitron window_cardinal_focus up";
    "super + ctrl + l" = "waitron window_cardinal_focus right";

    "super + c"         = "waitron window_snap middle";
    "super + f"         = "waitron window_maximize";

    "super + shift + c" = "waitron window_close";

    # Groups
    "super + {1-5}"         = "waitron group_activate_specific {1-5}";
    "super + shift + {1-5}" = "waitron group_move_window {1-5}";
    "super + ctrl + {1-5}"  = "waitron group_activate {1-5}";
  };
}
