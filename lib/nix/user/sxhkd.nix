{
  enable = true;
  extraPath = "/home/viz/bin/x";
  keybindings = {
    "Print"         = "screenshot -s";
    "super + Print" = "screenshot -u";

    "alt + p"                = "`menu run`";
    "alt + shift + Return"   = "eterm || tab -w st";
    "alt + shift + f"        = "dmenu_dir -h 1";
    "alt + s"                = "~/tmp/tst";
    "alt + ["                = "plumb";
    "alt + shift + q"        = "\$HOME/lib/wchf/wchfrc";
    "alt + shift + ctrl + q" = "waitron wm_quit 0";

    "super + v" = "chromium";
    "super + l" = "slock";
    "super + p" = "wmenu";
    "super + m" = "mus";
    "super + o" = "org-capture";
    "super + x" = "turnoff";
    "super + e" = "tab --parent-id emacsclient -c -a ''";

    "super + shift + r" = "pkill -USR1 redshift";
    "super + shift + f" = "flashfocus";

    # Control
    "super + shift + k" = "vol -i 1%";
    "super + shift + j" = "vol -d 1%";
    "super + shift + m" = "vol -t";
    "super + shift + l" = "doas brness -i 1";
    "super + shift + h" = "doas brness -d 1";

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
    "alt + h" = "waitron window_cardinal_focus left";
    "alt + j" = "waitron window_cardinal_focus down";
    "alt + k" = "waitron window_cardinal_focus up";
    "alt + l" = "waitron window_cardinal_focus right";

    "alt + c"         = "waitron window_snap middle";
    "alt + f"         = "waitron window_maximize";

    "alt + shift + c" = "waitron window_close";

    # Groups
    "alt + {1-5}"         = "waitron group_activate_specific {1-5}";
    "alt + shift + {1-5}" = "waitron group_move_window {1-5}";
    "alt + ctrl + {1-5}"  = "waitron group_activate {1-5}";
  };
}
