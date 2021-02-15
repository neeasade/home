{
  enable = false;

  rules = {
    name = {
      ".*" = "drawin ruler $RULER_WID";
    };

    role = {
      "browser" = "grep -q 2 /tmp/info/wm/groups/cur || { "
                  + "waitron window_focus $RULER_WID && "
                  + "waitron group_move_window 2; }";
    };

    instance = {
      "mpv-popup" = "mpopv $RULER_WID";
    };
  };
}
