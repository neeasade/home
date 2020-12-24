# To make sxhkd inherit the same PATH as the running X server,
# I had to remove PATH related options from the service file.
# Check modules/sxhkd-fix.nix (bad name ik)
{
  enable = true;
  keybindings = {
    "Print"         = "screenshot -s";
    "super + Print" = "screenshot -u";

    "super + r"                = "`menu run`";
    "super + shift + Return"   = "eterm || st";
    "super + shift + q"        = "\$HOME/lib/wchf/wchfrc";
    "super + shift + ctrl + q" = "waitron wm-quit 0";

    "super + v" = "chromium";
    "super + l" = "slock";
    "super + p" = "wmenu";
    "super + m" = "mus";
    "super + o" = "org-capture";
    "super + e" = "emacsclient -c -a ''";

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
    "super + w" = "waitron window-move   0 -50";
    "super + a" = "waitron window-move -50   0";
    "super + s" = "waitron window-move   0 +50";
    "super + d" = "waitron window-move +50   0";

    # Resize
    "super + shift + w" = "waitron window-resize    0 -50";
    "super + shift + a" = "waitron window-resize  -50   0";
    "super + shift + s" = "waitron window-resize    0 +50";
    "super + shift + d" = "waitron window-resize  +50   0";

    # Focus
    "super + ctrl + h" = "waitron window-cardinal-focus left";
    "super + ctrl + j" = "waitron window-cardinal-focus down";
    "super + ctrl + k" = "waitron window-cardinal-focus up";
    "super + ctrl + l" = "waitron window-cardinal-focus right";

    "super + c"         = "waitron window-snap middle";
    "super + f"         = "waitron window-maximize";

    "super + shift + c" = "waitron window-close";

    # Groups
    "super + {1-9}"         = "waitron group-switch {1-9}";
    "super + 0"             = "waitron group-switch 10";
    "super + shift + {1-9}" = "waitron group-move-window {1-9}";
    "super + shift + 0"     = "waitron group-move-window 10";
    "super + ctrl + 0"      = "waitron group-combine-or-toggle 10";
  };
}
