{ pkgs, config, ... }:

{
  enable = true;

  extraPackages = with pkgs; [
    kanshi
    mako
    wf-recorder
    xdg-desktop-portal-wlr
    gammastep
    grim
    slurp
    foot
    bemenu
    wl-clipboard
    libnotify
    # swaylock
  ];

  config = {
    core = {
      plugins = "window-rules decoration move grid place input autostart idle "
                + "command vswipe wm-actions wrot resize alpha scale invert "
                + "window-rules ";
      close_top_view = "<super> <shift> KEY_C | <super> BTN_MIDDLE";
      vwidth = "3";
      vheight = "3";
      preferred_decoration_mode = "server";
    };

    autostart = {
      display = "kanshi";
      notifs = "mako";
      # portal = "${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr";
      emacsdaemon = "DISPLAY=:0 emacs --daemon";
      autostart_wf_shell = "false";
      gamma = "gammastep"
              + " -l " + (toString config.location.latitude)
              + ":"    + (toString config.location.longitude);
    };

    move.activate = "<super> BTN_LEFT";
    resize.activate = "<super>";

    grid = {
      duration = "0";
      type = "none";
      slot_b = "<super> <ctrl> KEY_DOWN";
      slot_t = "<super> <ctrl> KEY_UP";
      slot_l = "<super> <ctrl> KEY_LEFT";
      slot_r = "<super> <ctrl> KEY_RIGHT";
    };

    place.mode = "center";

    input = {
      xkb_options = "caps:swapescape";
      disable_touchpad_while_typing = "true";
    };

    idle = {
      disable_on_fullscreen = "true";
      dpms_timeout = "300";
    };

    command = {
      binding_term = "<super> <shift> KEY_ENTER";
      command_term = "eterm || foot";
      binding_scrot = "KEY_SYSRQ";
      command_scrot = "screenshot";
      binding_scrot_up = "<super> KEY_SYSRQ";
      command_scrot_up = "screenshot -u";

      # This is autogen'd
      # (dolist (m '(("<super> KEY_E" "emacsclient -c")
      #        ("<super> KEY_N" "emacsclient -c --eval '(find-file \\\"~/doc/uni/notes/annotations.org\\\")'")
      #        ("<super> KEY_V" "chromium")
      #        ("<super> KEY_L" "swaylock")
      #        ("<super> KEY_O" "org-capture")
      #        ("<super> KEY_R" "menu run")
      #        ("<super> <shift> KEY_B" "notify-send \\\"$(bat -p)\\\" -t 5000")
      #        ("<super> <shift> KEY_V" "notify-send \\\"$(vol -g)\\\" -t 5000")
      #        ("<super> <shift> KEY_T" "notify-send \\\"$(date +%H:%M)\\\" -t 5000")
      #        ("<super> <shift> KEY_L" "doas /home/viz/bin/brness -i 1")
      #        ("<super> <shift> KEY_H" "doas /home/viz/bin/brness -d 1")
      #        ("<super> <shift> KEY_J" "vol -d 1%")
      #        ("<super> <shift> KEY_K" "vol -i 1%")
      #        ("<super> <shift> KEY_X" "turnoff")
      #        ("<super> <shift> KEY_R" "pkill -USR1 redshift")
      #        ))
      #   (insert (format "binding_%s = \"%s\";\ncommand_%1$s = \"%3$s\";\n"
      #             (vz/uniqify (car (split-string (cadr m) " ")))
      #             (car m)
      #             (cadr m))))
      binding_emacsclient-TR5J9R = "<super> KEY_E";
      command_emacsclient-TR5J9R = "emacsclient -c";
      binding_emacsclient-ln77t2 = "<super> KEY_N";
      command_emacsclient-ln77t2 = "emacsclient -c --eval '(find-file \"~/doc/uni/notes/annotations.org\")'";
      binding_chromium-zXspHx = "<super> KEY_V";
      command_chromium-zXspHx = "chromium";
      binding_swaylock-tfYhkI = "<super> KEY_L";
      command_swaylock-tfYhkI = "swaylock";
      binding_org-capture-AHzrnm = "<super> KEY_O";
      command_org-capture-AHzrnm = "org-capture";
      binding_menu-dhIV5q = "<super> KEY_R";
      command_menu-dhIV5q = "menu run";
      binding_notify-send-wg1YNT = "<super> <shift> KEY_B";
      command_notify-send-wg1YNT = "notify-send \"$(bat -p)\" -t 5000";
      binding_notify-send-iSlKZK = "<super> <shift> KEY_V";
      command_notify-send-iSlKZK = "notify-send \"$(vol -g)\" -t 5000";
      binding_notify-send-lh52L3 = "<super> <shift> KEY_T";
      command_notify-send-lh52L3 = "notify-send \"$(date +%H:%M)\" -t 5000";
      binding_doas-l3yoSu = "<super> <shift> KEY_L";
      command_doas-l3yoSu = "doas /home/viz/bin/brness -i 1";
      binding_doas-AnHp5J = "<super> <shift> KEY_H";
      command_doas-AnHp5J = "doas /home/viz/bin/brness -d 1";
      binding_vol-MWLU8b = "<super> <shift> KEY_J";
      command_vol-MWLU8b = "vol -d 1%";
      binding_vol-8nvgt9 = "<super> <shift> KEY_K";
      command_vol-8nvgt9 = "vol -i 1%";
      binding_turnoff-SvKnw5 = "<super> <shift> KEY_X";
      command_turnoff-SvKnw5 = "turnoff";
      binding_pkill-btt910 = "<super> <shift> KEY_R";
      command_pkill-btt910 = "pkill -USR1 redshift";
    };

    decoration = {
      border_size = "2";
      button_order = "close";
      font = "serif";
      title_height = "20";
      ignore_views = "app_id is \"chromium\" | title is \"vz/org-capture-frame\"";
    };

    wm-actions.toggle_fullscreen = "<super> KEY_F";

    vswipe = {
      duration = "0";
      enable_vertical = "true";
      enable_smooth_transistion = "true";
      fingers = "3";
    };

    wrot.activate = "<super> <ctrl> BTN_LEFT";

    alpha.modifier = "<super> <ctrl>";

    scale = {
      toggle = "<super> KEY_P";
      toggle_all = "<super> <shift> KEY_P";
      duration = "0";
      interactive = "true";
      middle_click_close = "true";
    };

    invert.toggle = "<super> KEY_I";

    # I don't actually use this since I'm really used to scale
    switcher = {
      next_view = "<super> <ctrl> KEY_J";
      prev_view = "<super> <ctrl> KEY_K";
      speed = "0";
    };

    window-rules = {
      rule_1 = "on created if title is \"vz/org-capture-frame\" then "
               + "snap top";
    };
  };
}
